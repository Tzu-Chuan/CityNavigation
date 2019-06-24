using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;

namespace ISTI_CityNavigation.Manage
{
    public partial class BackEndIndex : System.Web.UI.Page
    {
        protected void Page_Load(object sender, EventArgs e)
        {
            switch (LogInfo.competence)
            {
                case "SA":
                    Response.Redirect("~/Manage/MemberMag.aspx");
                    break;
                case "IDB":
                    Response.Redirect("~/Manage/IDB_Import.aspx");
                    break;
                case "ISTI":
                    Response.Redirect("~/Manage/ISTI_Import.aspx");
                    break;
            }
        }
    }
}