using System;
using System.IO;
using Microsoft.AspNetCore.Http;
using Poortwachter.Model;
using System.Net.Http;
using System.Text;
using System.Threading.Tasks;

namespace Poortwachter
{
    internal class Forwarder
    {
        public async Task Forward(HttpContext context, ReRoute route)
        {
            HttpClient client = new HttpClient();

            var requestMessage = await new RequestMapper().Map(context, route);



            var response = await client.SendAsync(requestMessage);

            Byte[] from = GetRequestBody(context.Request);
            var payload = Encoding.Default.GetString(from);

            await new ResponseMapper().Map(context, response, route);
        }

        private Byte[] GetRequestBody(HttpRequest request)
        {
            if (request.Body == null || !request.Body.CanRead)
            {
                return null;
            }

            using (var ms = new MemoryStream())
            {
                request.Body.CopyTo(ms);

                return ms.ToArray();
            }
        }
    }
}
