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
        public string UserName,CompStr,TokenStr;
        protected void Page_Load(object sender, EventArgs e)
        {
            TokenStr = Common.GenToken();
            if (!string.IsNullOrEmpty(LogInfo.mGuid))
            {
                UserName = LogInfo.name;
                CompStr = LogInfo.competence;

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