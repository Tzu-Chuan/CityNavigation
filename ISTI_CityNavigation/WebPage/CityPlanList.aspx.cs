using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;

namespace ISTI_CityNavigation.WebPage
{
    public partial class CityPlanList : System.Web.UI.Page
    {
        Common com = new Common();
        protected void Page_Load(object sender, EventArgs e)
        {
            //驗證token 資安用
            hfToken.Value = com.GenToken();
        }

    }
}