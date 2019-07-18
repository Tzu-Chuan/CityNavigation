using System;
using System.Collections.Generic;
using System.Configuration;
using System.Data;
using System.Data.SqlClient;
using System.Linq;
using System.Text;
using System.Web;


public class Travel_DB
{
    #region 私用
    string T_ID = string.Empty;
    string T_CityNo = string.Empty;
    string T_CityName = string.Empty;
    string T_HotelUseYear = string.Empty;
    string T_HotelUseRate = string.Empty;
    string T_PointYear = string.Empty;
    string T_PointYearDesc = string.Empty;
    string T_PointPeople = string.Empty;
    string T_HotelsYear = string.Empty;
    string T_Hotels = string.Empty;
    string T_HotelRoomsYear = string.Empty;
    string T_HotelRooms = string.Empty;
    string T_HotelAvgPriceYear = string.Empty;
    string T_HotelAvgPrice = string.Empty;
    string T_CreateDate = string.Empty;
    string T_CreateID = string.Empty;
    string T_CreateName = string.Empty;
    string T_Status = string.Empty;
    string T_Version = string.Empty;
    #endregion

    #region 公用
    public string _T_ID
    {
        set { T_ID = value; }
    }
    public string _T_CityNo
    {
        set { T_CityNo = value; }
    }
    public string _T_CityName
    {
        set { T_CityName = value; }
    }
    public string _T_HotelUseYear
    {
        set { T_HotelUseYear = value; }
    }
    public string _T_HotelUseRate
    {
        set { T_HotelUseRate = value; }
    }
    public string _T_PointYear
    {
        set { T_PointYear = value; }
    }
    public string _T_PointYearDesc
    {
        set { T_PointYearDesc = value; }
    }
    public string _T_PointPeople
    {
        set { T_PointPeople = value; }
    }
    public string _T_HotelsYear
    {
        set { T_HotelsYear = value; }
    }
    public string _T_Hotels
    {
        set { T_Hotels = value; }
    }
    public string _T_HotelRoomsYear
    {
        set { T_HotelRoomsYear = value; }
    }
    public string _T_HotelRooms
    {
        set { T_HotelRooms = value; }
    }
    public string _T_HotelAvgPriceYear
    {
        set { T_HotelAvgPriceYear = value; }
    }
    public string _T_HotelAvgPrice
    {
        set { T_HotelAvgPrice = value; }
    }
    public string _T_CreateDate
    {
        set { T_CreateDate = value; }
    }
    public string _T_CreateID
    {
        set { T_CreateID = value; }
    }
    public string _T_CreateName
    {
        set { T_CreateName = value; }
    }
    public string _T_Status
    {
        set { T_Status = value; }
    }
    public string _T_Version
    {
        set { T_Version = value; }
    }
    #endregion

    //取得當前最大版次
    public int getMaxVersin()
    {
        SqlCommand oCmd = new SqlCommand();
        oCmd.Connection = new SqlConnection(ConfigurationManager.AppSettings["ConnectionString"]);
        StringBuilder sb = new StringBuilder();

        sb.Append(@"
            SELECT MAX(T_Version) as strMax from Travel where T_Status='A'
        ");


        oCmd.CommandText = sb.ToString();
        oCmd.CommandType = CommandType.Text;
        SqlDataAdapter oda = new SqlDataAdapter(oCmd);
        DataTable dt = new DataTable();

        oda.Fill(dt);

        int strMaxNum = 0;
        if (dt.Rows[0]["strMax"].ToString().Trim() != "")
        {
            strMaxNum = Convert.ToInt32(dt.Rows[0]["strMax"].ToString().Trim());
        }

        return strMaxNum;
    }

    //取得交通總數列表資料
    public DataTable getTravelList()
    {
        SqlCommand oCmd = new SqlCommand();
        oCmd.Connection = new SqlConnection(ConfigurationManager.AppSettings["ConnectionString"]);
        StringBuilder sb = new StringBuilder();

        sb.Append(@"select * from Travel where T_CityNo=@T_CityNo and T_Status='A'");
        oCmd.Parameters.AddWithValue("@T_CityNo", T_CityNo);

        oCmd.CommandText = sb.ToString();
        oCmd.CommandType = CommandType.Text;
        SqlDataAdapter oda = new SqlDataAdapter(oCmd);
        DataTable dt = new DataTable();

        oda.Fill(dt);
        return dt;
    }

    public DataTable getTravel_All(string sortName, string sortMethod)
    {
        SqlCommand oCmd = new SqlCommand();
        oCmd.Connection = new SqlConnection(ConfigurationManager.AppSettings["ConnectionString"]);
        StringBuilder sb = new StringBuilder();

        sb.Append(@"select * from Travel where T_Status='A' order by convert(int," + sortName + @") " + sortMethod);

        oCmd.CommandText = sb.ToString();
        oCmd.CommandType = CommandType.Text;
        SqlDataAdapter oda = new SqlDataAdapter(oCmd);
        DataTable dt = new DataTable();

        oda.Fill(dt);
        return dt;
    }

}
