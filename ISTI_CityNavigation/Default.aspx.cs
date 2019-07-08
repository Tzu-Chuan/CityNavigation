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
            //if (!IsPostBack)
            //{
            //    hid_token.Value = com.GenToken();
            //    if (LogInfo.mGuid != "")
            //        Response.Redirect("~/WebPage/CityInfo.aspx");
            //}
            Response.Redirect("~/login.aspx");
        }

        protected void btn_Click(object sender, EventArgs e)
        {
            if (Common.VeriftyToken(hid_token.Value))
            {
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
            }
            else
            {
                JavaScript.AlertMessage(this.Page, "token驗證失敗");
            }
        }

        protected void Page_Init(object sender, EventArgs e)
        {
            ViewStateUserKey = User.Identity.Name;
        }

    }
}