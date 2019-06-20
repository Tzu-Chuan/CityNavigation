using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;
using System.Data;

namespace ISTI_CityNavigation.WebPage
{
    public partial class SmartCity : System.Web.UI.Page
    {
        CodeTable_DB ct_db = new CodeTable_DB();
        public string CityName;
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
        }
    }
}