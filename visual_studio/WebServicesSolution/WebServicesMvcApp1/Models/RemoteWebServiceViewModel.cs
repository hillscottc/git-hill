using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.Mvc;

namespace WebServicesMvcApp1.Models
{
    public class RemoteWebServiceViewModel
    {
        private WebServiceDataModelContainer dbContext = new WebServiceDataModelContainer();
        public RemoteWebService remoteWebService { get; set; }

        public RemoteWebServiceViewModel() { }

        public RemoteWebServiceViewModel(int id)
        {
            remoteWebService = dbContext.RemoteWebServices.Where(e => e.Id == id).SingleOrDefault();
            remoteWebService.Methods = dbContext.Methods.Where(e => e.RemoteWebServiceId == id).ToList();
        }
    
    }
}