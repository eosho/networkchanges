using System.Diagnostics;
using Microsoft.AspNetCore.Mvc;
using AzNetworkChange.Models;
using AzNetworkChange.Helpers;
using Newtonsoft.Json;

namespace AzNetworkChange.Controllers
{
  public class HomeController : Controller
  {
    //Replace Your Azure storage Information

    string StorageName = "";
    string StorageKey = "";
    string TableName = "networkchanges";

    public IActionResult Index()
    {
      string jsonData;
      AzureTables.GetAllEntity(StorageName, StorageKey, TableName, out jsonData);
      NetworkChangeModel changeModel = JsonConvert.DeserializeObject<NetworkChangeModel>(jsonData);

      return View(changeModel);
    }

    public IActionResult About()
    {
      ViewData["Message"] = "Your application description page.";

      return View();
    }

    public IActionResult Contact()
    {
      ViewData["Message"] = "Your contact page.";

      return View();
    }

    public IActionResult Privacy()
    {
      return View();
    }

    [ResponseCache(Duration = 0, Location = ResponseCacheLocation.None, NoStore = true)]
    public IActionResult Error()
    {
      return View(new ErrorViewModel { RequestId = Activity.Current?.Id ?? HttpContext.TraceIdentifier });
    }
  }
}
