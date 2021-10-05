using System;
using System.Net;
using System.Security.Cryptography;
using System.Text;

namespace AzNetworkChange.Helpers
{
  public class AzureTables
  {
    public static int GetAllEntity(string storageAccountName, string accessKey, string tableName, out string jsonData)
    {
      string tableEndpoint = string.Format("https://{0}.table.core.windows.net/{1}",
                                            storageAccountName,
                                            tableName);

      // Web request
      HttpWebRequest request = (HttpWebRequest)HttpWebRequest.Create(tableEndpoint);

      int query = tableName.IndexOf("?");
      if (query > 0)
      {
        tableName = tableName.Substring(0, query);
      }

      request = getRequestHeaders("GET", request, storageAccountName, accessKey, tableName);

      // Execute the request
      try
      {
        using (HttpWebResponse response = (HttpWebResponse)request.GetResponse())
        {
          using (System.IO.StreamReader r = new System.IO.StreamReader(response.GetResponseStream()))
          {
            jsonData = r.ReadToEnd();
            return (int)response.StatusCode;
          }
        }
      }
      catch (WebException ex)
      {
        // get the message from the exception response
        using (System.IO.StreamReader sr = new System.IO.StreamReader(ex.Response.GetResponseStream()))
        {
          jsonData = sr.ReadToEnd();
          // Log res if required
        }

        return (int)ex.Status;
      }
    }


    public static HttpWebRequest getRequestHeaders(string requestType, HttpWebRequest Newrequest, string storageAccountName, string accessKey, string resource, int Length = 0)
    {
      HttpWebRequest request = Newrequest;

      switch (requestType.ToUpper())
      {
        case "GET":
          request.Method = "GET";
          request.ContentType = "application/json";
          request.ContentLength = Length;
          request.Accept = "application/json;odata=nometadata";
          request.Headers.Add("x-ms-date", DateTime.UtcNow.ToString("R", System.Globalization.CultureInfo.InvariantCulture));
          request.Headers.Add("x-ms-version", "2015-04-05");
          request.Headers.Add("Accept-Charset", "UTF-8");
          request.Headers.Add("MaxDataServiceVersion", "3.0;NetFx");
          request.Headers.Add("DataServiceVersion", "1.0;NetFx");
          break;
        case "POST":
          request.Method = "POST";
          request.ContentType = "application/json";
          request.ContentLength = Length;
          request.Accept = "application/json;odata=nometadata";
          request.Headers.Add("x-ms-date", DateTime.UtcNow.ToString("R", System.Globalization.CultureInfo.InvariantCulture));
          request.Headers.Add("x-ms-version", "2015-04-05");
          request.Headers.Add("Accept-Charset", "UTF-8");
          request.Headers.Add("MaxDataServiceVersion", "3.0;NetFx");
          request.Headers.Add("DataServiceVersion", "1.0;NetFx");
          break;
        case "PUT":
          request.Method = "PUT";
          request.ContentLength = Length;
          request.ContentType = "application/json";
          request.Accept = "application/json;odata=nometadata";
          request.Headers.Add("x-ms-date", DateTime.UtcNow.ToString("R", System.Globalization.CultureInfo.InvariantCulture));
          request.Headers.Add("x-ms-version", "2015-04-05");
          request.Headers.Add("If-Match", "*");
          request.Headers.Add("Accept-Charset", "UTF-8");
          request.Headers.Add("MaxDataServiceVersion", "3.0;NetFx");
          request.Headers.Add("DataServiceVersion", "1.0;NetFx");
          break;
        case "DELETE":
          request.Method = "DELETE";
          request.ContentType = "application/json";
          request.Accept = "application/json;odata=nometadata";
          request.Headers.Add("x-ms-date", DateTime.UtcNow.ToString("R", System.Globalization.CultureInfo.InvariantCulture));
          request.Headers.Add("x-ms-version", "2015-04-05");
          request.Headers.Add("If-Match", "*");
          request.Headers.Add("Accept-Charset", "UTF-8");
          request.Headers.Add("MaxDataServiceVersion", "3.0;NetFx");
          request.Headers.Add("DataServiceVersion", "1.0;NetFx");
          break;
      }

      string sAuthorization = getAuthToken(request, storageAccountName, accessKey, resource);
      request.Headers.Add("Authorization", sAuthorization);
      return request;
    }

    public static string getAuthToken(HttpWebRequest request, string storageAccountName, string accessKey, string resource)
    {
      try
      {
        string sAuthTokn = "";

        string stringToSign = request.Headers["x-ms-date"] + "\n";

        stringToSign += "/" + storageAccountName + "/" + resource;

        HMACSHA256 hasher = new HMACSHA256(Convert.FromBase64String(accessKey));

        sAuthTokn = "SharedKeyLite " + storageAccountName + ":" + Convert.ToBase64String(hasher.ComputeHash(Encoding.UTF8.GetBytes(stringToSign)));

        return sAuthTokn;
      }
      catch (Exception ex)
      {

        throw ex;
      }
    }

  }
}
