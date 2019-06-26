using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;
using System.Data;

namespace ISTI_CityNavigation.WebPage
{
    public partial class CityInfoTable : System.Web.UI.Page
    {
        CodeTable_DB ct_db = new CodeTable_DB();
        public string CityName;
        public string CityTableClass;
        protected void Page_Load(object sender, EventArgs e)
        {
            if (!string.IsNullOrEmpty(Request.QueryString["city"]))
            {
                /// 查詢縣市代碼
                ct_db._C_Item = Request.QueryString["city"].ToString().Trim();
                DataTable CodeDt = ct_db.getCommonCode("02");
                if (CodeDt.Rows.Count > 0)
                    CityName = CodeDt.Rows[0]["C_Item_Cn"].ToString();
            }

            if (!string.IsNullOrEmpty(Request.QueryString["listname"]))
            {
                /// 查詢table類別
                switch (Request.QueryString["listname"].ToString().Trim())
                {
                        case "Population"://人口土地
                            CityTableClass = "人口土地";
                    break;
                        case "Travel"://觀光
                            CityTableClass = "觀光";
                    break;
                        case "Traffic"://交通
                            CityTableClass = "交通";
                    break;
                        case "Farming"://農業
                            CityTableClass = "農業";
                    break;
                        case "Industry"://產業
                            CityTableClass = "產業";
                    break;
                        case "Retail"://零售
                            CityTableClass = "零售";
                    break;
                        case "Safety"://智慧安全、治理
                            CityTableClass = "智慧安全、治理";
                    break;
                        case "Energy"://能源
                            CityTableClass = "能源";
                    break;
                        case "Health"://健康
                            CityTableClass = "健康";
                    break;
                        case "Education"://教育
                            CityTableClass = "教育";
                    break;
                }

            }

           
            
        }
    }
}