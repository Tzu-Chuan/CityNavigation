using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;

namespace ISTI_CityNavigation.handler
{
    public partial class SignOut : System.Web.UI.Page
    {
        Common com = new Common();
        protected void Page_Load(object sender, EventArgs e)
        {
            //string token = (string.IsNullOrEmpty(Request["Token"])) ? "" : Request["Token"].ToString().Trim();
            //if (com.VeriftyToken(token))
            //{
                Session.Abandon();
                Response.Redirect("~/Default.aspx");
            //}
        }
    }
}