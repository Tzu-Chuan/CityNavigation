using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;
using System.IO;

namespace ISTI_CityNavigation
{
    public partial class MasterPage : System.Web.UI.MasterPage
    {
        public string UserName;
        protected void Page_Load(object sender, EventArgs e)
        {
            if (LogInfo.mGuid != "")
            {
                UserName = LogInfo.name;

                /// ISTI 權限
                string pathName = Path.GetFileName(Request.PhysicalPath);
                if (LogInfo.competence == "ISTI")
                {
                    switch (pathName)
                    {
                        case "BudgetExecution.aspx":
                        case "CitySubsidyAnalyze.aspx":
                        case "SubsidyServiceAnalyze.aspx":
                        case "SubsidyCategoryAnalyze.aspx":
                        case "CityPlanList.aspx":
                            Response.Write("<script>alert('很抱歉，您沒有權限進入此頁面！'); history.go(-1);</script>");
                            break;
                    }
                }
            }
            else
                Response.Write("<script>alert('請先登入'); location.href='../Default.aspx';</script>");
        }
    }
}