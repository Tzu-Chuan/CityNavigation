using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;

namespace ISTI_CityNavigation.WebPage
{
    public partial class CityPlanList : System.Web.UI.Page
    {
        public string webServiceType, webCity, wSearchStr;
        protected void Page_Load(object sender, EventArgs e)
        {
            webServiceType = (string.IsNullOrEmpty(Request["cseServiceType"])) ? "" : Request["cseServiceType"].ToString().Trim();
            webCity = (string.IsNullOrEmpty(Request["cseCity"])) ? "" : Request["cseCity"].ToString().Trim();
            wSearchStr = (string.IsNullOrEmpty(Request["cseSearchTxt"])) ? "" : Request["cseSearchTxt"].ToString().Trim();
        }
    }
}