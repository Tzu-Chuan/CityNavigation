using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;

namespace ISTI_CityNavigation
{
    public partial class errorPage : System.Web.UI.Page
    {
        Common com = new Common();
        protected void Page_Load(object sender, EventArgs e)
        {
            Label1.Text = (Application["ErrorMsg"] == null) ? "您不可以進入本網頁!" : Application["ErrorMsg"].ToString();
            if (!IsPostBack)
                hid_token.Value = com.GenToken();
        }

        protected void lbtn_index_Click(object sender, EventArgs e)
        {
            if (com.VeriftyToken(hid_token.Value))
                Response.Redirect("login.aspx");
        }
    }
}