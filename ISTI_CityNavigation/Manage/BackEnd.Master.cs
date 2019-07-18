using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;
using System.IO;

namespace ISTI_CityNavigation.Manage
{
    public partial class BackEnd : System.Web.UI.MasterPage
    {
        public string UserName,CompStr, TokenStr;
        protected void Page_Load(object sender, EventArgs e)
        {
            TokenStr = Common.GenToken();
            if (!string.IsNullOrEmpty(LogInfo.mGuid))
            {
                UserName = LogInfo.name;
                CompStr = LogInfo.competence;
                CheckComp();
            }
            else
                Response.Write("<script>alert('請先登入'); location.href='../Default.aspx';</script>");
        }

        /// <summary>
        /// 權限管控
        /// </summary>
        private void CheckComp()
        {
            string pathName = Path.GetFileName(Request.PhysicalPath);
            if(LogInfo.competence == "IDB")
            {
                switch (pathName)
                {
                    case "MemberMag.aspx":
                    case "ISTI_Import.aspx":
                        Response.Write("<script>alert('很抱歉，您沒有權限進入此頁面！'); history.go(-1);</script>");
                        break;
                }
            }
            else if (LogInfo.competence == "ISTI")
            {
                switch (pathName)
                {
                    case "MemberMag.aspx":
                    case "IDB_Import.aspx":
                        Response.Write("<script>alert('很抱歉，您沒有權限進入此頁面！'); history.go(-1);</script>");
                        break;
                }
            }
            else if (LogInfo.competence == "IDBsr")
            {
                Response.Write("<script>alert('很抱歉，您沒有權限進入此頁面！'); history.go(-1);</script>");
            }
        }
    }
}