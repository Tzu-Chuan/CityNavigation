using System;
using System.Collections.Generic;
using System.Linq;
using System.Text.RegularExpressions;
using System.Web;
using System.Web.Security;
using System.Web.SessionState;

namespace ISTI_CityNavigation
{
    public class Global : System.Web.HttpApplication
    {

        protected void Application_Start(object sender, EventArgs e)
        {

        }

        protected void Session_Start(object sender, EventArgs e)
        {

        }

        protected void Application_BeginRequest(object sender, EventArgs e)
        {

        }

        protected void Application_AuthenticateRequest(object sender, EventArgs e)
        {

        }

        protected void Application_Error(object sender, EventArgs e)
        {
            HttpContext ctx = HttpContext.Current;
            Exception exception = ctx.Server.GetLastError();
            //int httpCode = ((HttpException)exception).GetHttpCode();
            bool IsExecAjax = false;
            Regex regexFormat = new Regex("exec\\S*\\.aspx", RegexOptions.IgnoreCase);
            IsExecAjax = (regexFormat.Match(Request.Path).Success == true) ? true : false;
            Exception ex = Server.GetLastError().GetBaseException();
            string Message = string.Format("訊息：{0}", ex.GetBaseException().Message);

            //===========explain：show message
            Server.ClearError();
            if (IsExecAjax)
            {
                Response.Write(Message);
            }
            else
            {
                Application["ErrorMsg"] = Message;
                Response.Redirect("~/errorPage.aspx");
            }
        }

        protected void Session_End(object sender, EventArgs e)
        {

        }

        protected void Application_End(object sender, EventArgs e)
        {

        }
    }
}