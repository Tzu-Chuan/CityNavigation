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
        Common com = new Common();
        protected void Page_Load(object sender, EventArgs e)
        {
            //hid_token.Value = com.GenToken();
            if (LogInfo.mGuid != "")
                Response.Redirect("~/WebPage/CityInfo.aspx");
        }

        protected void btn_Click(object sender, EventArgs e)
        {
            //if (com.VeriftyToken(hid_token.Value))
            //{
            string ab = AnbTxt.Value.Trim();
            string wo = WordTxt.Value.Trim();
            string strErrorMsg = "";

            AccountInfo accInfo = new Account().ExecLogon(ab, Common.sha1en(wo));
            if (accInfo != null)
            {
                Response.Redirect("~/WebPage/CityInfo.aspx");
            }
            else
            {
                strErrorMsg = "帳號密碼有誤";
                JavaScript.AlertMessage(this.Page, strErrorMsg);
            }
            //}
        }

        //protected void Page_Init(object sender, EventArgs e)
        //{
        //    ViewStateUserKey = User.Identity.Name;
        //}

    }
}