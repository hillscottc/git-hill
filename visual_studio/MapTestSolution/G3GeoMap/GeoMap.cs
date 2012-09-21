using System;
using System.Collections.Generic;
using System.Text;
using System.Data;
using System.Linq;

using System.Configuration;
using System.Data.SqlClient;

using MongoDB;

namespace Geneva3.G3GeoMap
{
    public class GeoMap
    {
        public List<GeoCity> GetCitiesByLatitudeLongitudeRadius(double latitude, double longitude, int radiusMiles)
        {
            using (var mongo = new Mongo(ConfigurationManager.ConnectionStrings["GeoServer"].ConnectionString))
            {
                mongo.Connect();
                var geoDB = mongo.GetDatabase("geo");
                var citiesCollection = geoDB.GetCollection<GeoCity>("cities");

                var filterDocument = new Document();
                filterDocument.Add("Coord", new Document().Add("$within", new Document().Add("$center", new object[] { new double[] { latitude, longitude }, radiusMiles / 60.0 })));
                filterDocument.Add("G3GeoID", new Document().Add("$ne", null));

                var foundCities = citiesCollection.Find(filterDocument).Documents.Distinct(new GeoCityComparer()).OrderBy(city => city.GoogleCode).ToList();
                mongo.Disconnect();

                return foundCities;
            }
        }

        public DataTable GetCitiesByPostalCodeRadius(string postalCode, int radiusMiles)
        {
            string conString = ConfigurationManager.ConnectionStrings["SqlServices"].ConnectionString;
            SqlConnection connection = new SqlConnection(conString);
            SqlCommand cmd = new SqlCommand();
            //cmd.CommandTimeout = 60;
            cmd.Connection = connection;
            cmd.CommandText = "GeoMap_GetCitiesByPostalCodeRadius";
            cmd.CommandType = CommandType.StoredProcedure;
            cmd.Parameters.Add("@FromZipCode", SqlDbType.NVarChar).Value = postalCode;
            cmd.Parameters.Add("@RadiusMiles", SqlDbType.Float).Value = (float)radiusMiles;
            SqlDataAdapter da;
            da = new SqlDataAdapter();
            da.SelectCommand = cmd;
            DataSet ds = new DataSet();
            cmd.Connection = connection;
            da.Fill(ds);

            da.Dispose();
            cmd.Dispose();
            connection.Close();
            connection.Dispose();

            return ds.Tables[0];
        }

        public DataTable GetDMAsByState(string state, string countryCode)
        {
            string conString = ConfigurationManager.ConnectionStrings["SqlServices"].ConnectionString;
            SqlConnection connection = new SqlConnection(conString);
            SqlCommand cmd = new SqlCommand();
            //cmd.CommandTimeout = 60;
            cmd.Connection = connection;
            cmd.CommandText = "GeoMap_GetDMAsByState";
            cmd.CommandType = CommandType.StoredProcedure;
            cmd.Parameters.Add("@State", SqlDbType.NVarChar).Value = state;
            cmd.Parameters.Add("@CountryCode", SqlDbType.NVarChar).Value = countryCode;
            SqlDataAdapter da;
            da = new SqlDataAdapter();
            da.SelectCommand = cmd;
            DataSet ds = new DataSet();
            cmd.Connection = connection;
            da.Fill(ds);

            da.Dispose();
            cmd.Dispose();
            connection.Close();
            connection.Dispose();

            return ds.Tables[0];
        }

    }


}
