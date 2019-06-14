using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;

namespace ISTI_CityNavigation
{
    public partial class MasterPage : System.Web.UI.MasterPage
    {
        public string UserName;
        protected void Page_Load(object sender, EventArgs e)
        {
            if (LogInfo.name != "")
            {
                UserName = LogInfo.name;
            }
            else
                Response.Write("<script>alert('請先登入'); location.href='../Default.aspx';</script>");
        }
    }
}