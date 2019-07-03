using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;

namespace ISTI_CityNavigation.Manage
{
    public partial class MemberLog : System.Web.UI.Page
    {
        Common com = new Common();
        protected void Page_Load(object sender, EventArgs e)
        {
            InfoToken.Value = com.GenToken();
        }
    }
}