using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;
using System.Data;

namespace ISTI_CityNavigation.WebPage
{
    public partial class CityCSE : System.Web.UI.Page
    {
        CodeTable_DB c_db = new CodeTable_DB();
        public string mode, wCity, cseCityName, wType, wServiceType, SearchStr;
        protected void Page_Load(object sender, EventArgs e)
        {
            mode = (string.IsNullOrEmpty(Request["mode"])) ? "" : Request["mode"].ToString().Trim();
            wCity = (string.IsNullOrEmpty(Request["wCity"])) ? "" : Request["wCity"].ToString().Trim();
            cseCityName = GetCityName();
            wType = (string.IsNullOrEmpty(Request["wType"])) ? "" : Request["wType"].ToString().Trim();
            wServiceType = (string.IsNullOrEmpty(Request["wServiceType"])) ? "" : Request["wServiceType"].ToString().Trim();
            SearchStr = (string.IsNullOrEmpty(Request["searchTxt"])) ? "" : Request["searchTxt"].ToString().Trim();
        }

        private string GetCityName()
        {
            string rVal = string.Empty;
            c_db._C_Item = wCity;
            DataTable dt = c_db.getCityName();
            if (dt.Rows.Count > 0)
            {
                rVal = dt.Rows[0]["C_Item_Cn"].ToString();
            }
            return rVal;
        }
    }
}