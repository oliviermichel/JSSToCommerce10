using System.Linq;
using System.Net.Http;
using System.Text;
using Microsoft.AspNetCore.Builder;
using Microsoft.AspNetCore.Hosting;
using Microsoft.AspNetCore.Http;
using Microsoft.AspNetCore.Mvc;
using Microsoft.Extensions.Configuration;
using Microsoft.Extensions.DependencyInjection;
using Microsoft.IdentityModel.Tokens;
using Newtonsoft.Json.Linq;
using Ocelot.DependencyInjection;
using Poortwachter;
using Poortwachter.Formatter;

namespace Gateway
{
    public class Startup
    {
        public Startup(IHostingEnvironment env)
        {

            var builder = new ConfigurationBuilder()
                .SetBasePath(env.ContentRootPath)
                .AddJsonFile("appsettings.json", optional: true, reloadOnChange: true)
                .AddJsonFile($"appsettings.{env.EnvironmentName}.json", optional: true)
                .AddJsonFile("ocelot.json")
                .AddEnvironmentVariables();

            //Configuration = configuration;
            Configuration = builder.Build();
        }

        public IConfiguration Configuration { get; }

        // This method gets called by the runtime. Use this method to add services to the container.
        // For more information on how to configure your application, visit https://go.microsoft.com/fwlink/?LinkID=398940
        public void ConfigureServices(IServiceCollection services)
        {
            var appSettingsSection = Configuration.GetSection("AppSettings");
            services.Configure<AppSettings>(appSettingsSection);
            
            // configure jwt authentication
            var appSettings = appSettingsSection.Get<AppSettings>();
            var key = Encoding.ASCII.GetBytes(appSettings.Secret);

            services.AddAuthentication()
                .AddJwtBearer("test", x =>
                {
                    x.RequireHttpsMetadata = false;
                    x.SaveToken = true;
                    x.TokenValidationParameters = new TokenValidationParameters
                    {
                        ValidateIssuerSigningKey = true,
                        IssuerSigningKey = new SymmetricSecurityKey(key),
                        ValidateIssuer = false,
                        ValidateAudience = false
                    };
                });

            services.AddCors(o => o.AddDefaultPolicy(builder =>
            {
                builder.AllowAnyOrigin()
                       .AllowAnyMethod()
                       .AllowAnyHeader();
            }));

            services.AddMemoryCache();
            services.AddOcelot(Configuration);

            services.AddMvc().SetCompatibilityVersion(CompatibilityVersion.Version_2_2);
        }

        // This method gets called by the runtime. Use this method to configure the HTTP request pipeline.
        public void Configure(IApplicationBuilder app, IHostingEnvironment env)
        {
            if (env.IsDevelopment())
            {
                app.UseDeveloperExceptionPage();
            }
            app.UseAuthentication();
            app.UseCors();

            
            

            app.Map("/api", config =>
            {
                // Liminal? https://en.wikipedia.org/wiki/Liminal
                config.UsePoortwachter(c =>
                {
                    var scheme = Configuration.GetValue<string>("ReRoutes:0:DownstreamScheme");
                    var host = Configuration.GetValue<string>("ReRoutes:0:DownstreamHostAndPorts:0:Host");
                    var port = Configuration.GetValue<string>("ReRoutes:0:DownstreamHostAndPorts:0:Port");
                    var hostRoot = scheme + "://" + host + ":" + port + "/api";
                    c.ModifyGlobalRequestHeaders((context, headers) =>
                    {
                        var environment =
                            Configuration.GetValue<string>("ReRoutes:0:UpstreamHeaderTransform:Environment");
                        var language = Configuration.GetValue<string>("ReRoutes:0:UpstreamHeaderTransform:Language");
                        var currency = Configuration.GetValue<string>("ReRoutes:0:UpstreamHeaderTransform:Currency");
                        var shopName = Configuration.GetValue<string>("ReRoutes:0:UpstreamHeaderTransform:ShopName");
                        headers.Clear();
                        headers.AddHeader("Environment", environment);
                        headers.AddHeader("Language", language);
                        headers.AddHeader("Currency", currency);
                        headers.AddHeader("ShopName", shopName);
                    });
                    //c.AddSitecoreTokenToRequestHeaders("eyJhbGciOiJSUzI1NiIsImtpZCI6IkE4MUI1QjdCQTQzREM5RkVBRkJFMjM2ODdGNUZEMzg0RTEwM0YxQkMiLCJ0eXAiOiJKV1QiLCJ4NXQiOiJxQnRiZTZROXlmNnZ2aU5vZjFfVGhPRUQ4YncifQ.eyJuYmYiOjE2MDYzMDI4NzYsImV4cCI6MTYwNjMwNjQ3NiwiaXNzIjoiaHR0cHM6Ly9zYzEwaWRlbnRpdHlzZXJ2ZXIuZGV2LmxvY2FsIiwiYXVkIjpbImh0dHBzOi8vc2MxMGlkZW50aXR5c2VydmVyLmRldi5sb2NhbC9yZXNvdXJjZXMiLCJFbmdpbmVBUEkiLCJwb3N0bWFuX2FwaSJdLCJjbGllbnRfaWQiOiJwb3N0bWFuLWFwaSIsInN1YiI6IjU0ZTZkMWE3MGQxMDQwMDdiMDUwNWUzY2VkZDIwY2EwIiwiYXV0aF90aW1lIjoxNjA2MzAyODc2LCJpZHAiOiJsb2NhbCIsIm5hbWUiOiJzaXRlY29yZVxcQWRtaW4iLCJlbWFpbCI6IiIsInJvbGUiOlsic2l0ZWNvcmVcXENvbW1lcmNlIEFkbWluaXN0cmF0b3IiLCJzaXRlY29yZVxcQ3VzdG9tZXIgU2VydmljZSBSZXByZXNlbnRhdGl2ZSBBZG1pbmlzdHJhdG9yIiwic2l0ZWNvcmVcXEN1c3RvbWVyIFNlcnZpY2UgUmVwcmVzZW50YXRpdmUiLCJzaXRlY29yZVxcQ29tbWVyY2UgQnVzaW5lc3MgVXNlciIsInNpdGVjb3JlXFxQcmljZXIgTWFuYWdlciIsInNpdGVjb3JlXFxQcmljZXIiLCJzaXRlY29yZVxcUHJvbW90aW9uZXIgTWFuYWdlciIsInNpdGVjb3JlXFxQcm9tb3Rpb25lciIsInNpdGVjb3JlXFxNZXJjaGFuZGlzZXIiLCJzaXRlY29yZVxcUmVsYXRpb25zaGlwIEFkbWluaXN0cmF0b3IiXSwic2NvcGUiOlsib3BlbmlkIiwiRW5naW5lQVBJIiwicG9zdG1hbl9hcGkiXSwiYW1yIjpbInB3ZCJdfQ.GaW_Ui-r3v87RM6kYKU6ulu_dlrmnA4LwwrwyPso0RIOHZy8-5VIibqSB4kyXX8zUs3aL2ZuMW_vP7VoET6VY7ZfUSxdFEvJmWhKT51uOnBX_uOcQvBvWAXXKskGJyAAZzGxUZ9hrKYpc_fOBEkAPNlo7IvJlaaseO19G1NN1U0mATF4zd4CHjvwDXPT9Lz3kHzLQkLJdL87HiFk65gRQh9jFs3Mh1BGzQJb5NEecHZxPMy7LzAg_bnfzcfzIJyhM_0NkG4J36skRVq8NfhcuoHhKD729XEoyK5Hdvq085F791YxWwgLHH8V8nALzxhGVvviwXUhl4AO4nC4uEczVQ");
                    c.ReRoute("/catalog/{catalogId}/sellableitems/{sellableitemId}")
                     .Method(HttpMethod.Get)
                     .To(hostRoot + "/SellableItems('{catalogId},{sellableitemId},')?$expand=Components($expand=ChildComponents($expand=ChildComponents($expand=ChildComponents($expand=ChildComponents))))")
                     .Method(HttpMethod.Get);

                    c.ReRoute("/carts/me")
                     .Method(HttpMethod.Get)
                     .To((context, httpContext) =>
                     {
                        var token = httpContext.User.FindFirst("anonymous_user_id")?.Value;
                        c.AddTokenUserId(token);

                         return $"{hostRoot}/Carts('{token}')?$expand=Lines($expand=CartLineComponents($expand=ChildComponents)),Components";
                     })
                     .Method(HttpMethod.Get)
                     .AuthenticateWith("test");

                    c.ReRoute("/carts/me/addline")
                     .Method(HttpMethod.Post)
                     .To($"{hostRoot}/AddCartLine()")
                     .TransformBody((_, httpContext, bytes) => SetCartIdInBody(httpContext, bytes))
                     .Method(HttpMethod.Post)
                     .AuthenticateWith("test");

                    c.ReRoute("/carts/me/addemail")
                     .Method(HttpMethod.Post)
                     .To($"{hostRoot}/AddEmailToCart()")
                     .TransformBody((_, httpContext, bytes) => SetCartIdInBody(httpContext, bytes))
                     .Method(HttpMethod.Post)
                     .AuthenticateWith("test");

                    c.ReRoute("/carts/me/setfulfillment")
                     .Method(HttpMethod.Post)
                     .To($"{hostRoot}/SetCartFulfillment()")
                     .TransformBody((_, httpContext, bytes) => SetCartIdInBody(httpContext, bytes))
                     .Method(HttpMethod.Post)
                     .AuthenticateWith("test");

                    c.ReRoute("/carts/me/addgiftcardpayment")
                     .Method(HttpMethod.Post)
                     .To($"{hostRoot}/AddGiftCardPayment()")
                     .TransformBody((_, httpContext, bytes) => SetCartIdInBody(httpContext, bytes))
                     .Method(HttpMethod.Post)
                     .AuthenticateWith("test");

                    c.ReRoute("/carts/me/createorder")
                     .Method(HttpMethod.Post)
                     .To($"{hostRoot}/CreateOrder()")
                     .TransformBody((_, httpContext, bytes) => SetCartIdInBody(httpContext, bytes, id:"id"))
                     .Method(HttpMethod.Post)
                     .AuthenticateWith("test");

                    c.ReRoute("/carts/me/lines/{cartLineId}")
                     .Method(HttpMethod.Delete)
                     .To($"{hostRoot}/RemoveCartLine()")
                     .TransformBody((context, httpContext, bytes) =>
                     {
                         var token = httpContext.User.FindFirst("anonymous_user_id")?.Value;
                         var o = JObject.FromObject(new {
                             cartId = token,
                             cartLineId = context.Variables["cartLineId"]
                         });

                         return Encoding.Default.GetBytes(o.ToString());
                     })
                     .Method(HttpMethod.Delete)
                     .AuthenticateWith("test");

                    c.ReRoute("/customers/{customerId}")
                     .Method(HttpMethod.Get)
                     .To(hostRoot + "/Customers('{customerId}')?$expand=Components")
                     .Method(HttpMethod.Get)
                     .AuthenticateWith("test");
                });
            });

            app.Map("/identity", config =>
            {
                config.UseMvc();
            });
        }

        private byte[] SetCartIdInBody(HttpContext httpContext, byte[] body, string id = "cartId")
        {
            var token = httpContext.User.FindFirst("anonymous_user_id")?.Value;
            
            var json = Encoding.Default.GetString(body);
            var o = JObject.Parse(json);
            o[id] = token;

            return Encoding.Default.GetBytes(o.ToString());
        }

        
    }
}
