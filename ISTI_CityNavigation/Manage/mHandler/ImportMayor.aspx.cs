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
    public partial class ImportMayor : System.Web.UI.Page
    {
        Mayor_DB MR_DB = new Mayor_DB();
        ImportData_Log idl_db = new ImportData_Log();
        //建立共用參數
        string strErrorMsg = "";
        int strMaxVersion = 0;
        string chkYear = "";
        DateTime dtNow = DateTime.Now;
        protected void Page_Load(object sender, EventArgs e)
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
            dt.Columns.Add("MR_CityNo", typeof(string)).MaxLength = 2;
            dt.Columns.Add("MR_CityName", typeof(string)).MaxLength = 10;
            dt.Columns.Add("MR_MayorYear", typeof(string)).MaxLength = 3;
            dt.Columns.Add("MR_Mayor", typeof(string)).MaxLength = 50;
            dt.Columns.Add("MR_ViceMayorYear", typeof(string)).MaxLength = 3;
            dt.Columns.Add("MR_ViceMayor", typeof(string)).MaxLength = 50;
            dt.Columns.Add("MR_PoliticalPartyYear", typeof(string)).MaxLength = 3;
            dt.Columns.Add("MR_PoliticalParty", typeof(string)).MaxLength = 50;
            dt.Columns.Add("MR_AdAreaYear", typeof(string)).MaxLength = 3;
            dt.Columns.Add("MR_AdArea", typeof(string)).MaxLength = 10;
            dt.Columns.Add("MR_CreateDate", typeof(DateTime));
            dt.Columns.Add("MR_CreateID", typeof(string));
            dt.Columns.Add("MR_CreateName", typeof(string));
            dt.Columns.Add("MR_Status", typeof(string));
            dt.Columns.Add("MR_Version", typeof(int));

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

                    //簡易判斷這份Excel是不是市長/副市長的Excel
                    int cellsCount = sheet.GetRow(0).Cells.Count;
                    //1.判斷表頭欄位數
                    if (cellsCount != 5)
                    {
                        throw new Exception("請檢查是否為市長副市長的匯入檔案");
                    }
                    //2.檢查欄位名稱
                    if (sheet.GetRow(0).GetCell(1).ToString().Trim() != "直轄市/縣市長" || sheet.GetRow(0).GetCell(2).ToString().Trim() != "副縣/市長")
                    {
                        throw new Exception("請檢查是否為市長副市長的匯入檔案");
                    }

                    //取得當前最大版次 (+1變成現在版次)
                    strMaxVersion = MR_DB.getMaxVersin() + 1;

                    //取得代碼檔
                    CodeTable_DB code_db = new CodeTable_DB();
                    DataTable dtCode = code_db.getCommonCode("02");

                    string cityNo = string.Empty;

                    //資料從第四筆開始 最後一筆是合計不進資料庫
                    for (int j = 3; j < sheet.PhysicalNumberOfRows - 1; j++)
                    {
                        if (sheet.GetRow(j).GetCell(0).ToString().Trim() != "")
                        {
                            DataRow row = dt.NewRow();
                            cityNo = Common.GetCityCodeItem(dtCode, sheet.GetRow(j).GetCell(0).ToString().Trim());//縣市代碼
                            if (cityNo == "")
                            {
                                throw new Exception("第" + (j + 1) + "筆資料：" + sheet.GetRow(j).GetCell(0).ToString().Trim() + "不是一個正確的縣市名稱");
                            }

                            strErrorMsg = "行數:第" + (j + 1).ToString() + " 筆<br>";
                            row["MR_CityNo"] = cityNo;//縣市代碼
                            row["MR_CityName"] = sheet.GetRow(j).GetCell(0).ToString().Trim();//縣市名稱
                            row["MR_MayorYear"] = sheet.GetRow(1).GetCell(1).ToString().Trim().Replace("年", "");//直轄市/縣市長-資料年度(民國年)
                            row["MR_Mayor"] = sheet.GetRow(j).GetCell(1).ToString().Trim();//直轄市/縣市長
                            row["MR_ViceMayorYear"] = sheet.GetRow(1).GetCell(2).ToString().Trim().Replace("年", "");//副縣/市長-資料年度(民國年)
                            row["MR_ViceMayor"] = sheet.GetRow(j).GetCell(2).ToString().Trim();//副縣/市長
                            row["MR_PoliticalPartyYear"] = sheet.GetRow(1).GetCell(3).ToString().Trim().Replace("年", "");//推薦政黨-資料年度(民國年)
                            row["MR_PoliticalParty"] = sheet.GetRow(j).GetCell(3).ToString().Trim();//推薦政黨
                            row["MR_AdAreaYear"] = sheet.GetRow(1).GetCell(4).ToString().Trim().Replace("年", "");//行政區數-資料年度(民國年)
                            row["MR_AdArea"] = sheet.GetRow(j).GetCell(4).ToString().Trim();//行政區數
                            row["MR_CreateDate"] = dtNow;
                            row["MR_CreateID"] = LogInfo.mGuid;//上傳者GUID
                            row["MR_CreateName"] = LogInfo.name;//上傳者姓名
                            row["MR_Status"] = "A";
                            row["MR_Version"] = strMaxVersion;

                            if (chkYear == "")
                                chkYear = sheet.GetRow(1).GetCell(1).ToString().Trim().Replace("年", "");

                            dt.Rows.Add(row);
                        }

                    }

                    if (dt.Rows.Count > 0)
                    {
                        strErrorMsg = "";
                        BeforeBulkCopy(oConn, myTrans, chkYear);//檢查資料表裡面是不是有該年的資料
                        DoBulkCopy(myTrans, dt, strErrorMsg);//匯入
                        myTrans.Commit();//最後再commit
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
                    idl_db._IDL_Description = "檔案類別:市長副市長 , 狀態：上傳成功";
                    idl_db._IDL_ModId = LogInfo.mGuid;
                    idl_db._IDL_ModName = LogInfo.name;
                    idl_db.addLog();
                    Response.Write("<script type='text/JavaScript'>parent.feedbackFun('市長副市長匯入成功');</script>");
                }
                else
                {
                    /// Log
                    idl_db._IDL_Type = "ISTI";
                    idl_db._IDL_IP = Common.GetIPv4Address();
                    idl_db._IDL_Description = "檔案類別:市長副市長 , 狀態：上傳失敗";
                    idl_db._IDL_ModId = LogInfo.mGuid;
                    idl_db._IDL_ModName = LogInfo.name;
                    idl_db.addLog();
                    Response.Write("<script type='text/JavaScript'>parent.feedbackFun('" + strErrorMsg.Replace("'", "") + "');</script>");
                }
            }
        }

        //insert 前判斷是不是同年份有資料了
        private void BeforeBulkCopy(SqlConnection oConn, SqlTransaction oTran, string chkYear)
        {
            StringBuilder sb = new StringBuilder();
            sb.Append(@"
                declare @chkRowCount int = 0;
                select @chkRowCount = count(*) from Mayor where MR_MayorYear=@chkYear and MR_Status='A'

                if @chkRowCount>0
                    begin
                        update Mayor set MR_Status='D' where MR_MayorYear=@chkYear and MR_Status='A'
                    end
            ");
            SqlCommand oCmd = oConn.CreateCommand();
            oCmd.CommandText = sb.ToString();

            oCmd.Parameters.AddWithValue("@chkYear", chkYear);

            oCmd.Transaction = oTran;
            oCmd.ExecuteNonQuery();
        }

        //市長/副市長 BulkCopy
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
                sqlBC.DestinationTableName = "Mayor";

                /// 對應來源與目標資料欄位 左邊：C# DataTable欄位  右邊：資料庫Table欄位
                sqlBC.ColumnMappings.Add("MR_CityNo", "MR_CityNo");
                sqlBC.ColumnMappings.Add("MR_CityName", "MR_CityName");
                sqlBC.ColumnMappings.Add("MR_MayorYear", "MR_MayorYear");
                sqlBC.ColumnMappings.Add("MR_Mayor", "MR_Mayor");
                sqlBC.ColumnMappings.Add("MR_ViceMayorYear", "MR_ViceMayorYear");
                sqlBC.ColumnMappings.Add("MR_ViceMayor", "MR_ViceMayor");
                sqlBC.ColumnMappings.Add("MR_PoliticalPartyYear", "MR_PoliticalPartyYear");
                sqlBC.ColumnMappings.Add("MR_PoliticalParty", "MR_PoliticalParty");
                sqlBC.ColumnMappings.Add("MR_AdAreaYear", "MR_AdAreaYear");
                sqlBC.ColumnMappings.Add("MR_AdArea", "MR_AdArea");
                sqlBC.ColumnMappings.Add("MR_CreateDate", "MR_CreateDate");
                sqlBC.ColumnMappings.Add("MR_CreateID", "MR_CreateID");
                sqlBC.ColumnMappings.Add("MR_CreateName", "MR_CreateName");
                sqlBC.ColumnMappings.Add("MR_Status", "MR_Status");
                sqlBC.ColumnMappings.Add("MR_Version", "MR_Version");

                /// 開始寫入資料
                sqlBC.WriteToServer(srcData);
            }
        }
    }
}