using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;
using System.Data;
using Newtonsoft.Json;

namespace ISTI_CityNavigation.handler
{
    public partial class GetServiceTypeCount : System.Web.UI.Page
    {
        CityPlanTable_DB cpt_db = new CityPlanTable_DB();
        protected void Page_Load(object sender, EventArgs e)
        {
            ///-----------------------------------------------------
            ///功    能: 計算縣市領域別數量
            ///說    明:
            /// * Request["City"]: 縣市代碼
            ///-----------------------------------------------------
            string JsonStr = string.Empty;
            try
            {
                string City = (string.IsNullOrEmpty(Request["City"])) ? "" : Request["City"].ToString().Trim();
                string token = (string.IsNullOrEmpty(Request["Token"])) ? "" : Request["Token"].ToString().Trim();
                if (Common.VeriftyToken(token))
                {
                    DataTable dt = cpt_db.GetServiceTypeCount(City);
                    JsonStr = JsonConvert.SerializeObject(dt, Formatting.Indented);
                }
                else
                {
                    JsonStr = JsonConvert.SerializeObject(ExceptionUtil.GetErrorMassageJson("error"));
                }
            }
            catch (Exception ex)
            {
                JsonStr = JsonConvert.SerializeObject(ExceptionUtil.GetErrorMassageJson(ex.Message));
            }
            Response.ContentType = "application/json";
            Response.Write(JsonStr);
        }
    }
}