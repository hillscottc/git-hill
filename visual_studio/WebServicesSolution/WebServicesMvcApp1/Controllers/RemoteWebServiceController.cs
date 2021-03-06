﻿using System;
using System.Collections.Generic;
using System.Data;
using System.Data.Entity;
using System.Linq;
using System.Web;
using System.Web.Mvc;
using WebServicesMvcApp1.Models;


namespace WebServicesMvcApp1.Controllers
{
    public class RemoteWebServiceController : Controller
    {
        private WebServiceDataModelContainer db = new WebServiceDataModelContainer();

        //
        // GET: /RemoteWebService/

        public ActionResult Index()
        {
            return View(db.RemoteWebServices.ToList());
        }

        //
        // GET: /RemoteWebService/Details/5

        public ActionResult Details(int id = 0)
        {
            //RemoteWebService rws = db.RemoteWebServices.Find(id);
            RemoteWebService rws = db.RemoteWebServices.Include("Methods").Where(e => e.Id == id).SingleOrDefault();

            if (rws == null)
            {
                return HttpNotFound();
            }

            var detailModelView = new Models.ModelViews.RemoteWebService.DetailModelView(rws);


            return View(detailModelView);
        }

        //
        // GET: /RemoteWebService/Create

        public ActionResult Create()
        {
            return View();
        }

        //
        // POST: /RemoteWebService/Create

        [HttpPost]
        public ActionResult Create(RemoteWebService remotewebservice)
        {
            if (ModelState.IsValid)
            {
                db.RemoteWebServices.Add(remotewebservice);
                db.SaveChanges();
                return RedirectToAction("Index");
            }

            return View(remotewebservice);
        }

        //
        // GET: /RemoteWebService/Edit/5

        public ActionResult Edit(int id = 0)
        {
            //RemoteWebService remotewebservice = db.RemoteWebServices.Find(id);
            RemoteWebService rws = db.RemoteWebServices.Include("Methods").Where(e => e.Id == id).SingleOrDefault();

            if (rws == null)
            {
                return HttpNotFound();
            }

            var editModelView = new Models.ModelViews.RemoteWebService.EditModelView(rws);


            return View(editModelView);
        }

        //
        // POST: /RemoteWebService/Edit/5

        [HttpPost]
        public ActionResult Edit(Models.ModelViews.RemoteWebService.EditModelView model)
        {

            //RemoteWebService rws = db.RemoteWebServices.Include("Methods").Where(e => e.Id == model.Id).SingleOrDefault();
            RemoteWebService rws = db.RemoteWebServices.Find(model.Id);
            if (rws == null)
            {
                return HttpNotFound();
            }

            if (ModelState.IsValid)
            {
                rws.ServiceAddress = model.ServiceAddress;
                rws.ServiceName = model.ServiceName;
                rws.Wsdl = model.Wsdl;
                //rws.Methods = model.Methods;

                db.Entry(rws).State = EntityState.Modified;
                db.SaveChanges();
                return RedirectToAction("Index");
            }

            return View(model);
        }

        //
        // GET: /RemoteWebService/Delete/5

        public ActionResult Delete(int id = 0)
        {
            RemoteWebService remotewebservice = db.RemoteWebServices.Find(id);
            if (remotewebservice == null)
            {
                return HttpNotFound();
            }
            return View(remotewebservice);
        }

        //
        // POST: /RemoteWebService/Delete/5

        [HttpPost, ActionName("Delete")]
        public ActionResult DeleteConfirmed(int id)
        {
            RemoteWebService remotewebservice = db.RemoteWebServices.Find(id);
            db.RemoteWebServices.Remove(remotewebservice);
            db.SaveChanges();
            return RedirectToAction("Index");
        }

        protected override void Dispose(bool disposing)
        {
            db.Dispose();
            base.Dispose(disposing);
        }
    }
}