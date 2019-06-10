using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;
using NPOI.SS.UserModel; //-- v.1.2.4起 新增的。
using NPOI.XSSF.UserModel; //-- XSSF 用來產生Excel 2007檔案（.xlsx）
using System.Text;
using System.Data.SqlClient;
using System.Data;
using System.Configuration;

namespace ISTI_CityNavigation.Manage.mHandler
{
    public partial class ImportIDBFile : System.Web.UI.Page
    {
        CitySubMoney_DB csm_db = new CitySubMoney_DB();
        protected void Page_Load(object sender, EventArgs e)
        {
            ///-----------------------------------------------------
            ///功    能: 匯入工業局資料
            ///說    明:
            /// 
            ///-----------------------------------------------------

            /// Transaction
            SqlConnection oConn = new SqlConnection(ConfigurationManager.AppSettings["ConnectionString"].ToString());
            oConn.Open();
            SqlCommand oCmd = new SqlCommand();
            oCmd.Connection = oConn;
            SqlTransaction myTrans = oConn.BeginTransaction();
            oCmd.Transaction = myTrans;

            DataTable dt = CreateDataTable();

            try
            {
                HttpFileCollection uploadFiles = Request.Files;//檔案集合
                HttpPostedFile aFile = uploadFiles[0];

                IWorkbook workbook;// = new HSSFWorkbook();//创建Workbook对象
                workbook = new XSSFWorkbook(aFile.InputStream);

                ISheet sheet = workbook.GetSheetAt(0);//當前sheet



            }
            catch (Exception ex)
            {

            }
        }

        private DataTable CreateDataTable()
        {
            DataTable dt = new DataTable();
            dt.Columns.Add("C_City", typeof(string));
            dt.Columns.Add("C_PlanCount_NotAll", typeof(string));
            dt.Columns.Add("C_SubMoney_NotAll", typeof(string));
            dt.Columns.Add("C_PlanMoney_NotAll", typeof(string));
            dt.Columns.Add("C_AssignSubMoney", typeof(string));
            dt.Columns.Add("C_AssignTotalMoney", typeof(string));
            dt.Columns.Add("C_CitySubMoneyRatio_NotAll", typeof(string));
            dt.Columns.Add("C_CityTotalMoneyRatio_NotAll", typeof(string));
            dt.Columns.Add("C_PlanCount", typeof(string));
            dt.Columns.Add("C_SubMoney", typeof(string));
            dt.Columns.Add("C_PlanMoney", typeof(string));
            dt.Columns.Add("C_CitySubMoneyRatio", typeof(string));
            dt.Columns.Add("C_CityTotalMoneyRatio", typeof(string));
            dt.Columns.Add("C_CreateDate", typeof(DateTime));
            dt.Columns.Add("C_CreateId", typeof(string));
            dt.Columns.Add("C_CreateName", typeof(string));
            dt.Columns.Add("C_Version", typeof(Int32));
            dt.Columns.Add("C_Status", typeof(string));
            return dt;
        }
    }
}