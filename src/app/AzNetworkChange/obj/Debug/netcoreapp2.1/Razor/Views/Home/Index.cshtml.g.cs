#pragma checksum "C:\Users\eroshoko.NORTHAMERICA\OneDrive - Microsoft\Cx\Walgreens\wba-events-monitoring\src\app\AzNetworkChange\Views\Home\Index.cshtml" "{ff1816ec-aa5e-4d10-87f7-6f4963833460}" "4e2999710710aae6d72d47ef52a328cc5e09e159"
// <auto-generated/>
#pragma warning disable 1591
[assembly: global::Microsoft.AspNetCore.Razor.Hosting.RazorCompiledItemAttribute(typeof(AspNetCore.Views_Home_Index), @"mvc.1.0.view", @"/Views/Home/Index.cshtml")]
[assembly:global::Microsoft.AspNetCore.Mvc.Razor.Compilation.RazorViewAttribute(@"/Views/Home/Index.cshtml", typeof(AspNetCore.Views_Home_Index))]
namespace AspNetCore
{
    #line hidden
    using System;
    using System.Collections.Generic;
    using System.Linq;
    using System.Threading.Tasks;
    using Microsoft.AspNetCore.Mvc;
    using Microsoft.AspNetCore.Mvc.Rendering;
    using Microsoft.AspNetCore.Mvc.ViewFeatures;
#line 1 "C:\Users\eroshoko.NORTHAMERICA\OneDrive - Microsoft\Cx\Walgreens\wba-events-monitoring\src\app\AzNetworkChange\Views\_ViewImports.cshtml"
using AzNetworkChange;

#line default
#line hidden
#line 2 "C:\Users\eroshoko.NORTHAMERICA\OneDrive - Microsoft\Cx\Walgreens\wba-events-monitoring\src\app\AzNetworkChange\Views\_ViewImports.cshtml"
using AzNetworkChange.Models;

#line default
#line hidden
    [global::Microsoft.AspNetCore.Razor.Hosting.RazorSourceChecksumAttribute(@"SHA1", @"4e2999710710aae6d72d47ef52a328cc5e09e159", @"/Views/Home/Index.cshtml")]
    [global::Microsoft.AspNetCore.Razor.Hosting.RazorSourceChecksumAttribute(@"SHA1", @"4a0461cd0ea95eb1763141559b23523cf9afcf31", @"/Views/_ViewImports.cshtml")]
    public class Views_Home_Index : global::Microsoft.AspNetCore.Mvc.Razor.RazorPage<AzNetworkChange.Models.NetworkChangeModel>
    {
        #pragma warning disable 1998
        public async override global::System.Threading.Tasks.Task ExecuteAsync()
        {
#line 1 "C:\Users\eroshoko.NORTHAMERICA\OneDrive - Microsoft\Cx\Walgreens\wba-events-monitoring\src\app\AzNetworkChange\Views\Home\Index.cshtml"
  
  ViewData["Title"] = "Home Page";

#line default
#line hidden
            BeginContext(43, 2, true);
            WriteLiteral("\r\n");
            EndContext();
            BeginContext(95, 484, true);
            WriteLiteral(@"
<div>
  <h3 class=""p-3 text-center"">Azure Network resource changes</h3>
</div>
<br />
<div>
  <table class=""table w-auto small table-striped table-bordered"">
    <thead class="""">
      <tr>
        <th>Subscription Id</th>
        <th>Resource Id</th>
        <th>Resource Type</th>
        <th>Changed By</th>
        <th>Before Value</th>
        <th>After Value</th>
        <th>Changed Property</th>
        <th>Time</th>
      </tr>
    </thead>
    <tbody>
");
            EndContext();
#line 26 "C:\Users\eroshoko.NORTHAMERICA\OneDrive - Microsoft\Cx\Walgreens\wba-events-monitoring\src\app\AzNetworkChange\Views\Home\Index.cshtml"
       if (Model.Value != null)
      {
        foreach (var item in Model.Value)
        {

#line default
#line hidden
            BeginContext(675, 32, true);
            WriteLiteral("          <tr>\r\n            <td>");
            EndContext();
            BeginContext(708, 17, false);
#line 31 "C:\Users\eroshoko.NORTHAMERICA\OneDrive - Microsoft\Cx\Walgreens\wba-events-monitoring\src\app\AzNetworkChange\Views\Home\Index.cshtml"
           Write(item.Subscription);

#line default
#line hidden
            EndContext();
            BeginContext(725, 23, true);
            WriteLiteral("</td>\r\n            <td>");
            EndContext();
            BeginContext(749, 15, false);
#line 32 "C:\Users\eroshoko.NORTHAMERICA\OneDrive - Microsoft\Cx\Walgreens\wba-events-monitoring\src\app\AzNetworkChange\Views\Home\Index.cshtml"
           Write(item.ResourceId);

#line default
#line hidden
            EndContext();
            BeginContext(764, 23, true);
            WriteLiteral("</td>\r\n            <td>");
            EndContext();
            BeginContext(788, 17, false);
#line 33 "C:\Users\eroshoko.NORTHAMERICA\OneDrive - Microsoft\Cx\Walgreens\wba-events-monitoring\src\app\AzNetworkChange\Views\Home\Index.cshtml"
           Write(item.ResourceType);

#line default
#line hidden
            EndContext();
            BeginContext(805, 23, true);
            WriteLiteral("</td>\r\n            <td>");
            EndContext();
            BeginContext(829, 14, false);
#line 34 "C:\Users\eroshoko.NORTHAMERICA\OneDrive - Microsoft\Cx\Walgreens\wba-events-monitoring\src\app\AzNetworkChange\Views\Home\Index.cshtml"
           Write(item.ChangedBy);

#line default
#line hidden
            EndContext();
            BeginContext(843, 23, true);
            WriteLiteral("</td>\r\n            <td>");
            EndContext();
            BeginContext(867, 16, false);
#line 35 "C:\Users\eroshoko.NORTHAMERICA\OneDrive - Microsoft\Cx\Walgreens\wba-events-monitoring\src\app\AzNetworkChange\Views\Home\Index.cshtml"
           Write(item.BeforeValue);

#line default
#line hidden
            EndContext();
            BeginContext(883, 23, true);
            WriteLiteral("</td>\r\n            <td>");
            EndContext();
            BeginContext(907, 15, false);
#line 36 "C:\Users\eroshoko.NORTHAMERICA\OneDrive - Microsoft\Cx\Walgreens\wba-events-monitoring\src\app\AzNetworkChange\Views\Home\Index.cshtml"
           Write(item.AfterValue);

#line default
#line hidden
            EndContext();
            BeginContext(922, 23, true);
            WriteLiteral("</td>\r\n            <td>");
            EndContext();
            BeginContext(946, 20, false);
#line 37 "C:\Users\eroshoko.NORTHAMERICA\OneDrive - Microsoft\Cx\Walgreens\wba-events-monitoring\src\app\AzNetworkChange\Views\Home\Index.cshtml"
           Write(item.ChangedProperty);

#line default
#line hidden
            EndContext();
            BeginContext(966, 23, true);
            WriteLiteral("</td>\r\n            <td>");
            EndContext();
            BeginContext(990, 14, false);
#line 38 "C:\Users\eroshoko.NORTHAMERICA\OneDrive - Microsoft\Cx\Walgreens\wba-events-monitoring\src\app\AzNetworkChange\Views\Home\Index.cshtml"
           Write(item.Timestamp);

#line default
#line hidden
            EndContext();
            BeginContext(1004, 24, true);
            WriteLiteral("</td>\r\n          </tr>\r\n");
            EndContext();
#line 40 "C:\Users\eroshoko.NORTHAMERICA\OneDrive - Microsoft\Cx\Walgreens\wba-events-monitoring\src\app\AzNetworkChange\Views\Home\Index.cshtml"
        }
      }
      else
      {

#line default
#line hidden
            BeginContext(1069, 57, true);
            WriteLiteral("        <tr>\r\n          <td>No Data</td>\r\n        </tr>\r\n");
            EndContext();
#line 47 "C:\Users\eroshoko.NORTHAMERICA\OneDrive - Microsoft\Cx\Walgreens\wba-events-monitoring\src\app\AzNetworkChange\Views\Home\Index.cshtml"
      }

#line default
#line hidden
            BeginContext(1135, 34, true);
            WriteLiteral("    </tbody>\r\n  </table>\r\n</div>\r\n");
            EndContext();
        }
        #pragma warning restore 1998
        [global::Microsoft.AspNetCore.Mvc.Razor.Internal.RazorInjectAttribute]
        public global::Microsoft.AspNetCore.Mvc.ViewFeatures.IModelExpressionProvider ModelExpressionProvider { get; private set; }
        [global::Microsoft.AspNetCore.Mvc.Razor.Internal.RazorInjectAttribute]
        public global::Microsoft.AspNetCore.Mvc.IUrlHelper Url { get; private set; }
        [global::Microsoft.AspNetCore.Mvc.Razor.Internal.RazorInjectAttribute]
        public global::Microsoft.AspNetCore.Mvc.IViewComponentHelper Component { get; private set; }
        [global::Microsoft.AspNetCore.Mvc.Razor.Internal.RazorInjectAttribute]
        public global::Microsoft.AspNetCore.Mvc.Rendering.IJsonHelper Json { get; private set; }
        [global::Microsoft.AspNetCore.Mvc.Razor.Internal.RazorInjectAttribute]
        public global::Microsoft.AspNetCore.Mvc.Rendering.IHtmlHelper<AzNetworkChange.Models.NetworkChangeModel> Html { get; private set; }
    }
}
#pragma warning restore 1591
