using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;
using System.Data;
using System.Xml;

namespace ISTI_CityNavigation.handler
{
    public partial class UserLogin : System.Web.UI.Page
    {
        protected void Page_Load(object sender, EventArgs e)
        {
            ///-----------------------------------------------------
            ///功    能: 會員登入
            ///說明:
            /// * Request["acc"]: 帳號
            /// * Request["pwd"]: 密碼
            ///-----------------------------------------------------
            XmlDocument xDoc = new XmlDocument();
            try
            {
                string acc = (string.IsNullOrEmpty(Request.Form["acc"])) ? "" : Request.Form["acc"].ToString().Trim();
                string pw = (string.IsNullOrEmpty(Request.Form["pwd"])) ? "" : Request.Form["pwd"].ToString().Trim();

                AccountInfo accInfo = new Account().ExecLogon(acc, Common.sha1en(pw));
                string xmlstr = string.Empty;
                if (accInfo != null)
                {
                    xmlstr = "<?xml version='1.0' encoding='utf-8'?><root><Response>登入成功</Response><Redirect>WebPage/CityInfo.aspx</Redirect></root>";
                    xDoc.LoadXml(xmlstr);
                }
                else
                    xDoc = ExceptionUtil.GetErrorMassageDocument("帳號密碼有誤");

            }
            catch (Exception ex)
            {
                xDoc = ExceptionUtil.GetExceptionDocument(ex);
            }
            Response.ContentType = System.Net.Mime.MediaTypeNames.Text.Xml;
            xDoc.Save(Response.Output);
        }
    }
}