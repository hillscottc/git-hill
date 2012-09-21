using System;
using System.Collections.Generic;
using System.Collections.Specialized;
using System.Text;
using System.Web;
using System.Net;

namespace Geneva3.G3GeoMap
{
	public class GeoCoding
	{
		const string GOOGLE_URI = "http://maps.google.com/maps/geo?q=";

		[Serializable]
		public class Coordinates
		{
			decimal longitude;
			public decimal Latitude
			{
				get
				{
					return latitude;
				}
				set
				{
					this.latitude = value;
				}
			}

			decimal latitude;
			public decimal Longitude
			{
				get
				{
					return longitude;
				}
				set
				{
					this.longitude = value;
				}
			}

            private int accuracyLevel;

            public int AccuracyLevel
            {
                get { return accuracyLevel; }
                set { accuracyLevel = value; }
            }

            private string accuracyDescription;

            public string AccuracyDescription
            {
                get { return accuracyDescription; }
                set { accuracyDescription = value; }
            }

            private string errorMessage;

            public string ErrorMessage
            {
                get { return errorMessage; }
                set { errorMessage = value; }
            }

            public override string ToString()
            {
                return String.Format("Longitude: {0}, Latitude: {1}, Accuracy: {2}", Longitude, Latitude, AccuracyLevel);
            }
		}

		/// <summary>
		/// Gets a Coordinate from a address.
		/// </summary>
		/// <param name="appFullyQualifiedDomainName">The application fully qualified domain name.
		/// <remarks>
		/// <example>http://webservices.geneva3.webvisible.com</example>
		/// </remarks>
		/// </param>
		/// <param name="address">An address.
		/// <remarks>
		/// <example>1600 Amphitheatre Parkway Mountain View, CA 94043</example>
		/// </remarks>
		/// </param>
		/// <returns>A spatial coordinate that contains the latitude and longitude of the address.</returns>
		public static Coordinates GetCoordinates(string appFullyQualifiedDomainName, string address)
		{
            Coordinates coordinate = new Coordinates();
            coordinate = GetGeoCoordinates(appFullyQualifiedDomainName, address);

            if (coordinate != null)
            {
                if (!string.IsNullOrEmpty(coordinate.ErrorMessage))
                {
                    throw new Exception(coordinate.ErrorMessage);
                }
                else
                {
                    if (coordinate.AccuracyLevel >= 0 && coordinate.AccuracyLevel <= 3)
                    {
                        throw new Exception(coordinate.AccuracyDescription);
                    }
                }
            }
            else
            {
                throw new Exception("Request could not be processed");
            }

            return coordinate;
		}

        private static Coordinates GetGeoCoordinates(string appFullyQualifiedDomainName, string address)
        {
            WebClient client = new WebClient();
            Coordinates coordinate = null;
            int accuracyLevel = 0;
            string accuracyDescription = string.Empty;
            decimal latitude = 0;
            decimal longitude = 0;
            string error = string.Empty;

            try
            {
                if (string.IsNullOrEmpty(address))
                {
                    throw new Exception("Address must not be a null or empty string.");
                }

                // to access the Maps API geocoder directly using server-side scripting,
                // send a request to http://maps.google.com/maps/geo? with the following parameters in the URI: 
                // q: the address that you want to geocode
                // key: your API key
                // output: the format in which the output should be generated. the options are xml, kml, csv, or json
                Uri uri = new Uri(string.Format("{0}{1}&output=csv&key={2}", GOOGLE_URI,
                    HttpUtility.UrlEncode(address), GetGoogleMapApiKey(appFullyQualifiedDomainName)));

                // the first number is the http status code, 
                // the second is the accuracy, 
                // the third is the latitude, 
                // the fourth one is the longitude.
                string[] geocodeInfo = client.DownloadString(uri).Split(',');

                

                switch (geocodeInfo[0])
                {
                    case "200":
                        // No errors occurred; the address was successfully parsed and its geocode has been returned.
                        error = string.Empty;
                        break;
                    case "400":
                        error = "A directions request could not be successfully parsed.";
                        break;
                    case "500":
                        error = "A geocoding or directions request could not be successfully processed, yet the exact reason for the failure is not known.";
                        break;
                    case "601":
                        error = "The HTTP q parameter was either missing or had no value. For geocoding requests, this means that an empty address was specified as input. For directions requests, this means that no query was specified in the input.";
                        break;
                    case "602":
                        error = "No corresponding geographic location could be found for the specified address. This may be due to the fact that the address is relatively new, or it may be incorrect.";
                        break;
                    case "603":
                        error = "The geocode for the given address or the route for the given directions query cannot be returned due to legal or contractual reasons.";
                        break;
                    case "604":
                        error = "The GDirections object could not compute directions between the points mentioned in the query. This is usually because there is no route available between the two points, or because we do not have data for routing in that region.";
                        break;
                    case "610":
                        error = "The given key is either invalid or does not match the domain for which it was given.";
                        break;
                    case "620":
                        error = "The given key has gone over the requests limit in the 24 hour period.";
                        break;
                    default:
                        error = "Google Maps API unknown error.";
                        break;
                }

                if (!string.IsNullOrEmpty(error))
                {
                    throw new Exception(error);
                }

                accuracyLevel = int.Parse(geocodeInfo[1]);

                switch (accuracyLevel)
                {
                    case 0:
                        accuracyDescription = "Unknown location.";
                        break;
                    case 1:
                        accuracyDescription = "Country level accuracy.";
                        break;
                    case 2:
                        accuracyDescription = "Region (state, province, prefecture, etc.) level accuracy.";
                        break;
                    case 3:
                        accuracyDescription = "Sub-region (county, municipality, etc.) level accuracy.";
                        break;
                    case 4:
                        accuracyDescription = "Town (city, village) level accuracy.";
                        break;
                    case 5:
                        accuracyDescription = "Post code (zip code) level accuracy.";
                        break;
                    case 6:
                        accuracyDescription = "Street level accuracy.";
                        break;
                    case 7:
                        accuracyDescription = "Intersection level accuracy.";
                        break;
                    case 8:
                        accuracyDescription = "Address level accuracy.";
                        break;
                    case 9:
                        accuracyDescription = "Premise (building name, property name, shopping center, etc.) level accuracy.";
                        break;
                }

                latitude = decimal.Parse(geocodeInfo[2]);
                longitude = decimal.Parse(geocodeInfo[3]);


            }
            catch (Exception ex)
            {
                //TODO:log the stack trace of the exception
                accuracyLevel = 0;
                error = ex.Message;    
            }

            coordinate = new Coordinates();
            coordinate.Latitude = latitude;
            coordinate.Longitude = longitude;
            coordinate.AccuracyLevel = accuracyLevel;
            coordinate.AccuracyDescription = accuracyDescription;
            coordinate.ErrorMessage = error;

            return coordinate;
        }

		static Dictionary<string, string> _googleMapApiDomainKeyCollection;
		static Dictionary<string, string> googleMapApiDomainKeyCollection
		{
			get
			{
				if (_googleMapApiDomainKeyCollection == null)
				{
					_googleMapApiDomainKeyCollection = new Dictionary<string, string>();

					// this is a section which is defined in both Geneva and GWS web.config files
					NameValueCollection section = 
						(NameValueCollection)System.Configuration.ConfigurationManager.GetSection("googleMapApiDomainKeys");

					foreach (string domain in section.Keys)
					{
						_googleMapApiDomainKeyCollection.Add(domain, section[domain]);
					}
				}

				return _googleMapApiDomainKeyCollection;
			}
		}

		public static string GetGoogleMapApiKey(string appFullyQualifiedDomainName)
		{
			if (!googleMapApiDomainKeyCollection.ContainsKey(appFullyQualifiedDomainName.ToLower()))
			{
				// not found? return google map api key for domain www.geneva3.webvisible.com
				return "ABQIAAAA06ME4wAJ0G6J2oTFAC2e8hQlWcdUSPCjwFY-fW2vmKmHKDdgBxR0F26uYdtlaed_vrHqA6PInb2AQg";
			}

			return googleMapApiDomainKeyCollection[appFullyQualifiedDomainName.ToLower()];
		}
	}
}
