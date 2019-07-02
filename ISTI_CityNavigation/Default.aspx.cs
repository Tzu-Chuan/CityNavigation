using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.Services;
using System.Web.UI;
using System.Web.UI.WebControls;
using System.Xml;

namespace ISTI_CityNavigation
{
    public partial class Default : System.Web.UI.Page
    {
        protected void Page_Load(object sender, EventArgs e)
        {
            if (LogInfo.mGuid != "")
                Response.Redirect("~/WebPage/CityInfo.aspx");
        }

        protected void lbtnDelete_Click(object sender, EventArgs e)
        {
            XmlDocument xDoc = new XmlDocument();
            string ab = (string.IsNullOrEmpty(Request.Form["AnbHid"])) ? "" : Request.Form["AnbHid"].ToString().Trim();
            string wo = (string.IsNullOrEmpty(Request.Form["WordHid"])) ? "" : Request.Form["WordHid"].ToString().Trim();
            string strErrorMsg = "";

            AccountInfo accInfo = new Account().ExecLogon(ab, Common.sha1en(wo));
            string xmlstr = string.Empty;
            if (accInfo != null)
            {
                Response.Redirect("~/WebPage/CityInfo.aspx");
            }
            else
            {
                strErrorMsg = "帳號密碼有誤";
                Response.Write("<script type='text/JavaScript'>alert('" + strErrorMsg + "');</script>");
            }
        }
    }
}