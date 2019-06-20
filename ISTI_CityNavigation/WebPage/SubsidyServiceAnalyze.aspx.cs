using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;

namespace ISTI_CityNavigation.WebPage
{
    public partial class SubsidyServiceAnalyze : System.Web.UI.Page
    {
        protected void Page_Load(object sender, EventArgs e)
        {
            if(LogInfo.competence== "ISTI")
            {
                Response.Write("<script>alert('很抱歉，您沒有權限進入此頁面！'); location.href='../Default.aspx';</script>");
            }
        }
    }
}