﻿using System;
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
        protected void Page_Init(object sender, EventArgs e)
        {
            ViewStateUserKey = User.Identity.Name;
        }

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
                string ab = (string.IsNullOrEmpty(Request.Form["anb"])) ? "" : Request.Form["anb"].ToString().Trim();
                string wo = (string.IsNullOrEmpty(Request.Form["word"])) ? "" : Request.Form["word"].ToString().Trim();

                AccountInfo accInfo = new Account().ExecLogon(ab, Common.sha1en(wo));
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