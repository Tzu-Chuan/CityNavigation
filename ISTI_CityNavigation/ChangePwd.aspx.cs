using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;

namespace ISTI_CityNavigation
{
    public partial class ChangePwd : System.Web.UI.Page
    {
        protected void Page_Load(object sender, EventArgs e)
        {
            InfoToken.Value = Common.GenToken();
            string ckTime = (string.IsNullOrEmpty(Request["ck"])) ? "" : Request["ck"].ToString().Trim();
            if (ckTime != "")
            {
                DateTime setTime = DateTime.Parse(Common.Decrypt(ckTime));
                setTime = setTime.AddHours(1);
                DateTime NowTime = DateTime.Now;
                if (NowTime > setTime)
                    JavaScript.AlertMessageRedirect(this.Page, "該網址已失效", "Login.aspx");
            }
            else
            {
                Response.Redirect("~/Login.aspx");
            }
        }
    }
}