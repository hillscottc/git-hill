using System;
using System.Collections.Generic;
using System.Data;
using System.Data.Entity;
using System.Linq;
using System.Web;
using System.Web.Mvc;
using WebServicesMvcApp1.Models;

namespace WebServicesMvcApp1.Controllers
{
    public class MethodController : Controller
    {
        private WebServiceDataModelContainer db = new WebServiceDataModelContainer();

        //
        // GET: /Method/

        public ActionResult Index()
        {
            var methods = db.Methods.Include(m => m.RemoteWebService);
            return View(methods.ToList());
        }

        //
        // GET: /Method/Details/5

        public ActionResult Details(int id = 0)
        {
            Method method = db.Methods.Find(id);
            if (method == null)
            {
                return HttpNotFound();
            }
            return View(method);
        }

        //
        // GET: /Method/Create

        public ActionResult Create()
        {
            ViewBag.RemoteWebServiceId = new SelectList(db.RemoteWebServices, "Id", "ServiceName");
            return View();
        }

        //
        // POST: /Method/Create

        [HttpPost]
        public ActionResult Create(Method method)
        {
            if (ModelState.IsValid)
            {
                db.Methods.Add(method);
                db.SaveChanges();
                return RedirectToAction("Index");
            }

            ViewBag.RemoteWebServiceId = new SelectList(db.RemoteWebServices, "Id", "ServiceName", method.RemoteWebServiceId);
            return View(method);
        }

        //
        // GET: /Method/Edit/5

        public ActionResult Edit(int id = 0)
        {
            Method method = db.Methods.Find(id);
            if (method == null)
            {
                return HttpNotFound();
            }
            ViewBag.RemoteWebServiceId = new SelectList(db.RemoteWebServices, "Id", "ServiceName", method.RemoteWebServiceId);
            return View(method);
        }

        //
        // POST: /Method/Edit/5

        [HttpPost]
        public ActionResult Edit(Method method)
        {
            if (ModelState.IsValid)
            {
                db.Entry(method).State = EntityState.Modified;
                db.SaveChanges();
                return RedirectToAction("Index");
            }
            ViewBag.RemoteWebServiceId = new SelectList(db.RemoteWebServices, "Id", "ServiceName", method.RemoteWebServiceId);
            return View(method);
        }

        //
        // GET: /Method/Delete/5

        public ActionResult Delete(int id = 0)
        {
            Method method = db.Methods.Find(id);
            if (method == null)
            {
                return HttpNotFound();
            }
            return View(method);
        }

        //
        // POST: /Method/Delete/5

        [HttpPost, ActionName("Delete")]
        public ActionResult DeleteConfirmed(int id)
        {
            Method method = db.Methods.Find(id);
            db.Methods.Remove(method);
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