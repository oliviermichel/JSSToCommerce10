using System;
using System.Collections.Generic;
using System.Configuration;
using System.Dynamic;
using System.Net;
using System.Net.Http;
using System.Net.Http.Headers;
using System.Text;
using System.Threading.Tasks;
using Microsoft.Extensions.Caching.Memory;
using Microsoft.Extensions.DependencyInjection;
using Newtonsoft.Json;
using Poortwachter.Model;


namespace Poortwachter.Builder
{
    public class TokenBuilder
    {
        private static readonly TokenBuilder instance = new TokenBuilder();
        private static MemoryCache _cache;

        static TokenBuilder()
        {
            if (_cache == null)
            {
                _cache = new MemoryCache(new MemoryCacheOptions());
            }
        }

        private TokenBuilder()
        {
            if (_cache == null)
            {
                _cache = new MemoryCache(new MemoryCacheOptions());
            }
        }

        public static TokenBuilder Instance => instance;


        public async Task<string> GetXCAccessToken(string userTokenId)
        {

            if (string.IsNullOrEmpty(userTokenId))
            {
                userTokenId = "Cart1";
            }

            string sitecoreTokenId = string.Empty;

            if (_cache.TryGetValue<string>(userTokenId, out sitecoreTokenId))
                return sitecoreTokenId;

            HttpResponseMessage resp;

            using (var httpClient = new HttpClient())
            {
                var tokenAPI = ConfigurationManager.AppSettings["tokenAPI"];
                string grantType = ConfigurationManager.AppSettings["grant_type"];
                string client_id = ConfigurationManager.AppSettings["client_id"];
                string scope = ConfigurationManager.AppSettings["scope"];
                string username = ConfigurationManager.AppSettings["username"];
                string password = ConfigurationManager.AppSettings["password"];

                var req = new HttpRequestMessage(HttpMethod.Post, tokenAPI);
                req.Headers.Add("Accept", "application/json");
                req.Content = new FormUrlEncodedContent(new Dictionary<string, string>
                {
                    { "grant_type", grantType },
                    { "client_id", client_id },
                    { "scope", scope },
                    { "username", username },
                    { "password", password }
                });

                req.Content.Headers.ContentType = new MediaTypeHeaderValue("application/x-www-form-urlencoded");

                resp = await httpClient.SendAsync(req);
                if (resp.StatusCode != HttpStatusCode.OK)
                {
                    return resp.ReasonPhrase;
                }

                var respString = await resp.Content.ReadAsStringAsync();
                var respJson = JsonConvert.DeserializeObject<ConnectTokenResponse>(respString);
                sitecoreTokenId = respJson.access_token;
                int expiration = respJson.expires_in;
                _cache.Set<string>(userTokenId, sitecoreTokenId, new MemoryCacheEntryOptions
                {
                    AbsoluteExpiration = DateTime.Now.AddSeconds(expiration - 60),
                    SlidingExpiration = TimeSpan.FromSeconds(expiration / 2)
                });
                return sitecoreTokenId;

            }


        }
    }
}
