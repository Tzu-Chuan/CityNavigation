using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;
using NPOI.SS.UserModel;//-- v.1.2.4起 新增的。
using NPOI.XSSF.UserModel;//-- XSSF 用來產生Excel 2007檔案（.xlsx）
using System.Text;
using System.Data.SqlClient;
using System.Data;
using System.Configuration;

namespace ISTI_CityNavigation.Manage.mHandler
{
    public partial class ImportRetail : System.Web.UI.Page
    {
        Retail_DB RL_DB = new Retail_DB();
        ImportData_Log idl_db = new ImportData_Log();
        //建立共用參數
        string strErrorMsg = "";
        int strMaxVersion = 0;
        string chkYear = "";
        DateTime dtNow = DateTime.Now;
        protected void Page_Load(object sender, EventArgs e)
        {
            //讀取Token值
            string token = (string.IsNullOrEmpty(Request["InfoToken"])) ? "" : Request["InfoToken"].ToString().Trim();
            if (VeriftyToken(token))
            {
                //建立共用connection & transaction
                SqlConnection oConn = new SqlConnection(ConfigurationManager.AppSettings["ConnectionString"].ToString());
                oConn.Open();
                SqlCommand oCmd = new SqlCommand();
                oCmd.Connection = oConn;
                SqlTransaction myTrans = oConn.BeginTransaction();
                oCmd.Transaction = myTrans;

                //建立DataTable Bulk Copy用
                DataTable dt = new DataTable();
                dt.Columns.Add("Re_CityNo", typeof(string)).MaxLength = 2; ;
                dt.Columns.Add("Re_CityName", typeof(string)).MaxLength = 10;
                dt.Columns.Add("Re_StreetStandYear", typeof(string)).MaxLength = 3;
                dt.Columns.Add("Re_StreetStand", typeof(string)).MaxLength = 20;
                dt.Columns.Add("Re_Re_StreetVendorYear", typeof(string)).MaxLength = 3;
                dt.Columns.Add("Re_StreetVendor", typeof(string)).MaxLength = 20;
                dt.Columns.Add("Re_StreetVendorIncomeYear", typeof(string)).MaxLength = 3;
                dt.Columns.Add("Re_StreetVendorIncome", typeof(string)).MaxLength = 20;
                dt.Columns.Add("Re_StreetVendorAvgIncomeYear", typeof(string)).MaxLength = 3;
                dt.Columns.Add("Re_StreetVendorAvgIncome", typeof(string)).MaxLength = 20;
                dt.Columns.Add("Re_RetailBusinessSalesYear", typeof(string)).MaxLength = 3;
                dt.Columns.Add("Re_RetailBusinessSales", typeof(string)).MaxLength = 20;
                dt.Columns.Add("Re_RetailBusinessSalesRateYearDesc", typeof(string)).MaxLength = 20;
                dt.Columns.Add("Re_RetailBusinessSalesRate", typeof(string)).MaxLength = 7;
                dt.Columns.Add("Re_RetailBusinessAvgSalesYear", typeof(string)).MaxLength = 3;
                dt.Columns.Add("Re_RetailBusinessAvgSales", typeof(string)).MaxLength = 20;
                dt.Columns.Add("Re_CreateDate", typeof(DateTime));
                dt.Columns.Add("Re_CreateID", typeof(string));
                dt.Columns.Add("Re_CreateName", typeof(string));
                dt.Columns.Add("Re_Status", typeof(string));
                dt.Columns.Add("Re_Version", typeof(int));


                try
                {
                    HttpFileCollection uploadFiles = Request.Files;//檔案集合
                    HttpPostedFile aFile = uploadFiles[0];
                    //判斷有沒有檔案
                    if (uploadFiles.Count < 1 || aFile.FileName == "")
                    {
                        throw new Exception("請選擇檔案");
                    }

                    //有檔案繼續往下做
                    if (uploadFiles.Count > 0)
                    {
                        string extension = (System.IO.Path.GetExtension(aFile.FileName) == "") ? "" : System.IO.Path.GetExtension(aFile.FileName);
                        if (extension != ".xls" && extension != ".xlsx")
                        {
                            throw new Exception("請選擇xls或xlsx檔案上傳");
                        }

                        IWorkbook workbook;// = new HSSFWorkbook();//创建Workbook对象
                        workbook = new XSSFWorkbook(aFile.InputStream);

                        ISheet sheet = workbook.GetSheetAt(0);//當前sheet

                        //簡易判斷這份Excel是不是零售的Excel
                        int cellsCount = sheet.GetRow(0).Cells.Count;
                        //1.判斷表頭欄位數
                        if (cellsCount != 8)
                        {
                            throw new Exception("請檢查是否為零售的匯入檔案");
                        }
                        //2.檢查欄位名稱
                        if (sheet.GetRow(0).GetCell(1).ToString().Trim() != "攤販經營家數" || sheet.GetRow(0).GetCell(2).ToString().Trim() != "攤販從業人數")
                        {
                            throw new Exception("請檢查是否為零售的匯入檔案");
                        }

                        //取得當前最大版次 (+1變成現在版次)
                        strMaxVersion = RL_DB.getMaxVersin() + 1;

                        //取得代碼檔
                        CodeTable_DB code_db = new CodeTable_DB();
                        DataTable dtCode = code_db.getCommonCode("02");

                        string cityNo = string.Empty;

                        //資料從第四筆開始 最後一筆是合計不進資料庫
                        for (int j = 3; j < sheet.PhysicalNumberOfRows - 1; j++)
                        {
                            if (sheet.GetRow(j).GetCell(0).ToString().Trim() != "" && sheet.GetRow(j).GetCell(0).ToString().Trim() != "全台平均")
                            {
                                DataRow row = dt.NewRow();
                                cityNo = Common.GetCityCodeItem(dtCode, sheet.GetRow(j).GetCell(0).ToString().Trim());//縣市代碼
                                if (cityNo == "")
                                {
                                    throw new Exception("第" + (j + 1) + "筆資料：" + sheet.GetRow(j).GetCell(0).ToString().Trim() + "不是一個正確的縣市名稱");
                                }

                                strErrorMsg = "行數:第" + (j + 1).ToString() + " 筆<br>";
                                row["Re_CityNo"] = cityNo;//縣市代碼
                                row["Re_CityName"] = sheet.GetRow(j).GetCell(0).ToString().Trim();//縣市名稱
                                row["Re_StreetStandYear"] = sheet.GetRow(1).GetCell(1).ToString().Trim().Replace("年", "");//攤販經營家數-資料年度(民國年)
                                row["Re_StreetStand"] = sheet.GetRow(j).GetCell(1).ToString().Trim();//攤販經營家數-家
                                row["Re_Re_StreetVendorYear"] = sheet.GetRow(1).GetCell(2).ToString().Trim().Replace("年", "");//攤販從業人數-資料年度(民國年)
                                row["Re_StreetVendor"] = sheet.GetRow(j).GetCell(2).ToString().Trim();//攤販從業人數-人
                                row["Re_StreetVendorIncomeYear"] = sheet.GetRow(1).GetCell(3).ToString().Trim().Replace("年", "");//攤販全年收入-資料年度(民國年)
                                row["Re_StreetVendorIncome"] = sheet.GetRow(j).GetCell(3).ToString().Trim();//攤販全年收入-千元
                                row["Re_StreetVendorAvgIncomeYear"] = sheet.GetRow(1).GetCell(4).ToString().Trim().Replace("年", "");//攤販全年平均收入-資料年度(民國年)
                                row["Re_StreetVendorAvgIncome"] = sheet.GetRow(j).GetCell(4).ToString().Trim();//攤販全年平均收入-千元
                                row["Re_RetailBusinessSalesYear"] = sheet.GetRow(1).GetCell(5).ToString().Trim().Replace("年", "");//零售業營利事業銷售額-資料年度(民國年)
                                row["Re_RetailBusinessSales"] = sheet.GetRow(j).GetCell(5).ToString().Trim();//零售業營利事業銷售額-千元
                                row["Re_RetailBusinessSalesRateYearDesc"] = sheet.GetRow(1).GetCell(6).ToString().Trim();//零售業營利事業銷售額成長率-年度敘述 EX: 106-107年
                                row["Re_RetailBusinessSalesRate"] = sheet.GetRow(j).GetCell(6).ToString().Trim();//零售業營利事業銷售額成長率
                                row["Re_RetailBusinessAvgSalesYear"] = sheet.GetRow(1).GetCell(7).ToString().Trim().Replace("年", "");//零售業營利事業平均每家銷售額-資料年度(民國年)
                                row["Re_RetailBusinessAvgSales"] = sheet.GetRow(j).GetCell(7).ToString().Trim();//零售業營利事業平均每家銷售額-千元
                                row["Re_CreateDate"] = dtNow;
                                row["Re_CreateID"] = LogInfo.mGuid;//上傳者GUID
                                row["Re_CreateName"] = LogInfo.name;//上傳者姓名
                                row["Re_Status"] = "A";
                                row["Re_Version"] = strMaxVersion;

                                if (chkYear == "")
                                    chkYear = sheet.GetRow(1).GetCell(5).ToString().Trim().Replace("年", "");

                                dt.Rows.Add(row);
                            }

                        }

                        if (dt.Rows.Count > 0)
                        {
                            strErrorMsg = "";
                            BeforeBulkCopy(oConn, myTrans, chkYear);//檢查資料表裡面是不是有該年的資料
                            DoBulkCopy(myTrans, dt, strErrorMsg);//匯入
                            myTrans.Commit();                   //最後再commit
                        }
                    }

                }
                catch (Exception ex)
                {
                    strErrorMsg += "錯誤訊息:" + ex.Message + "<br>";
                    strErrorMsg += "(欄位名稱請參考上傳範例檔)";
                    myTrans.Rollback();
                }
                finally
                {
                    oCmd.Connection.Close();
                    oConn.Close();

                    if (strErrorMsg == "")
                    {
                        /// Log
                        idl_db._IDL_Type = "ISTI";
                        idl_db._IDL_IP = Common.GetIPv4Address();
                        idl_db._IDL_Description = "檔案類別:零售 , 狀態：上傳成功";
                        idl_db._IDL_ModId = LogInfo.mGuid;
                        idl_db._IDL_ModName = LogInfo.name;
                        idl_db.addLog();
                        Response.Write("<script type='text/JavaScript'>parent.feedbackFun('零售匯入成功');</script>");
                    }
                    else
                    {
                        /// Log
                        idl_db._IDL_Type = "ISTI";
                        idl_db._IDL_IP = Common.GetIPv4Address();
                        idl_db._IDL_Description = "檔案類別:零售 , 狀態：上傳失敗";
                        idl_db._IDL_ModId = LogInfo.mGuid;
                        idl_db._IDL_ModName = LogInfo.name;
                        idl_db.addLog();
                        Response.Write("<script type='text/JavaScript'>parent.feedbackFun('" + strErrorMsg.Replace("'", "") + "');</script>");
                    }
                }
            }
            else
            {
                strErrorMsg = "連線失敗請重新登入";
                Response.Write("<script type='text/JavaScript'>parent.feedbackFun('" + strErrorMsg.Replace("'", "") + "');</script>");
            }
        }

        //insert 前判斷是不是同年份有資料了
        private void BeforeBulkCopy(SqlConnection oConn, SqlTransaction oTran, string chkYear)
        {
            StringBuilder sb = new StringBuilder();
            sb.Append(@"
                declare @chkRowCount int = 0;
                select @chkRowCount = count(*) from Retail where Re_RetailBusinessSalesYear=@chkYear and Re_Status='A'

                if @chkRowCount>0
                    begin
                        update Retail set Re_Status='D' where Re_RetailBusinessSalesYear=@chkYear and Re_Status='A'
                    end
            ");
            SqlCommand oCmd = oConn.CreateCommand();
            oCmd.CommandText = sb.ToString();

            oCmd.Parameters.AddWithValue("@chkYear", chkYear);

            oCmd.Transaction = oTran;
            oCmd.ExecuteNonQuery();
        }

        //零售 BulkCopy
        private void DoBulkCopy(SqlTransaction oTran, DataTable srcData, string errorMsg)
        {
            SqlBulkCopyOptions setting = SqlBulkCopyOptions.CheckConstraints | SqlBulkCopyOptions.TableLock;
            using (SqlBulkCopy sqlBC = new SqlBulkCopy(oTran.Connection, setting, oTran))
            {
                sqlBC.BulkCopyTimeout = 600; ///設定逾時的秒數
                //sqlBC.BatchSize = 1000; ///設定一個批次量寫入多少筆資料, 設定值太小會影響效能 
                ////設定 NotifyAfter 屬性，以便在每複製 10000 個資料列至資料表後，呼叫事件處理常式。
                //sqlBC.NotifyAfter = 10000;
                ///設定要寫入的資料庫
                sqlBC.DestinationTableName = "Retail";

                /// 對應來源與目標資料欄位 左邊：C# DataTable欄位  右邊：資料庫Table欄位
                sqlBC.ColumnMappings.Add("Re_CityNo", "Re_CityNo");
                sqlBC.ColumnMappings.Add("Re_CityName", "Re_CityName");
                sqlBC.ColumnMappings.Add("Re_StreetStandYear", "Re_StreetStandYear");
                sqlBC.ColumnMappings.Add("Re_StreetStand", "Re_StreetStand");
                sqlBC.ColumnMappings.Add("Re_Re_StreetVendorYear", "Re_Re_StreetVendorYear");
                sqlBC.ColumnMappings.Add("Re_StreetVendor", "Re_StreetVendor");
                sqlBC.ColumnMappings.Add("Re_StreetVendorIncomeYear", "Re_StreetVendorIncomeYear");
                sqlBC.ColumnMappings.Add("Re_StreetVendorIncome", "Re_StreetVendorIncome");
                sqlBC.ColumnMappings.Add("Re_StreetVendorAvgIncomeYear", "Re_StreetVendorAvgIncomeYear");
                sqlBC.ColumnMappings.Add("Re_StreetVendorAvgIncome", "Re_StreetVendorAvgIncome");
                sqlBC.ColumnMappings.Add("Re_RetailBusinessSalesYear", "Re_RetailBusinessSalesYear");
                sqlBC.ColumnMappings.Add("Re_RetailBusinessSales", "Re_RetailBusinessSales");
                sqlBC.ColumnMappings.Add("Re_RetailBusinessSalesRateYearDesc", "Re_RetailBusinessSalesRateYearDesc");
                sqlBC.ColumnMappings.Add("Re_RetailBusinessSalesRate", "Re_RetailBusinessSalesRate");
                sqlBC.ColumnMappings.Add("Re_RetailBusinessAvgSalesYear", "Re_RetailBusinessAvgSalesYear");
                sqlBC.ColumnMappings.Add("Re_RetailBusinessAvgSales", "Re_RetailBusinessAvgSales");
                sqlBC.ColumnMappings.Add("Re_CreateDate", "Re_CreateDate");
                sqlBC.ColumnMappings.Add("Re_CreateID", "Re_CreateID");
                sqlBC.ColumnMappings.Add("Re_CreateName", "Re_CreateName");
                sqlBC.ColumnMappings.Add("Re_Status", "Re_Status");
                sqlBC.ColumnMappings.Add("Re_Version", "Re_Version");

                /// 開始寫入資料
                sqlBC.WriteToServer(srcData);
            }
        }

        //判斷Token是否正確
        private bool VeriftyToken(string clientToken)
        {
            if (string.IsNullOrEmpty(clientToken)) return false;

            string serverToken = HttpContext.Current.Session["Token"].ToString();
            if (clientToken.Equals(serverToken))
                return true;
            else
                return false;
        }
    }
}