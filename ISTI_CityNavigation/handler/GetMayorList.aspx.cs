using System;
using System.Collections.Generic;
using System.Data;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;
using System.Xml;

namespace ISTI_CityNavigation.Manage.mHandler
{
    public partial class GetMayorList : System.Web.UI.Page
    {
        Mayor_DB n_db = new Mayor_DB();
        protected void Page_Load(object sender, EventArgs e)
        {
            ///-----------------------------------------------------
            ///功    能: 撈市長副市長列表
            ///-----------------------------------------------------
            XmlDocument xDoc = new XmlDocument();
            try
            {
                string MR_CityNo = (Request["CityNo"] != null) ? Request["CityNo"].ToString().Trim() : "";
                string token = (string.IsNullOrEmpty(Request.Form["Token"])) ? "" : Request.Form["Token"].ToString().Trim();

                if (Common.VeriftyToken(token))
                {
                    n_db._MR_CityNo = MR_CityNo;
                    DataTable dt = n_db.getMayorList();
                    string xmlstr = string.Empty;
                    xmlstr = DataTableToXml.ConvertDatatableToXML(dt, "dataList", "data_item");
                    xmlstr = "<?xml version='1.0' encoding='utf-8'?><root>" + xmlstr + "</root>";
                    xDoc.LoadXml(xmlstr);
                }
                else
                {
                    xDoc = ExceptionUtil.GetErrorMassageDocument("TokenFail");
                }
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