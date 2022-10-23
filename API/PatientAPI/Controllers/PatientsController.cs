using System;
using System.Collections.Generic;
using System.Linq;
using System.Threading.Tasks;
using Microsoft.AspNetCore.Mvc;
using Microsoft.EntityFrameworkCore;
using PatientAPI.Data;
using PatientAPI.Models;

namespace PatientsAPI.Controllers
{

    [ApiController]
    [Route("api/[controller]")]


    public class PatientsController : Controller
    {

        private readonly PatientsAPIDbContext dbContext;

        public PatientsController(PatientsAPIDbContext dbContext)
        {
            this.dbContext = dbContext;
        }


        [HttpGet]

        public async Task<IActionResult> GetPatients()
        {
            return Ok(await dbContext.Patients.ToListAsync());
        }

        [HttpGet]
        [Route("{id:guid}")]

        public async Task<IActionResult> GetPatient([FromRoute] Guid id)
        {
            var patient = await dbContext.Patients.FindAsync(id);

            if (patient == null)
            {
                return NotFound();
            }

            return Ok(patient);

        }

        [HttpPost]
        public async Task<IActionResult> AddPatient(AddPatientRequest addPatientRequest)

        {
            var patient = new Patient()
            {
                Id = Guid.NewGuid(),
                Address = addPatientRequest.Address,
                Email = addPatientRequest.Email,
                FullName = addPatientRequest.FullName,
                Phone = addPatientRequest.Phone
            };

            await dbContext.Patients.AddAsync(patient);
            await dbContext.SaveChangesAsync();

            return Ok(patient);
        }

        [HttpPut]
        [Route("{id:guid}")]
        public async Task<IActionResult> UpdatePatient([FromRoute] Guid id, UpdatePatientRequest updatePatientRequest)
        {
            var patient = await dbContext.Patients.FindAsync(id);

            if (patient != null)
            {
                patient.FullName = updatePatientRequest.FullName;
                patient.Address = updatePatientRequest.Address;
                patient.Phone = updatePatientRequest.Phone;
                patient.Email = updatePatientRequest.Email;

                await dbContext.SaveChangesAsync();

                return Ok(patient);
            }

            return NotFound();
        }

        [HttpDelete]

        public async Task<IActionResult> DeletePatient([FromRoute] Guid id)
        {
            var patient = await dbContext.Patients.FindAsync(id);

            if (patient != null)
            {
                dbContext.Remove(patient);
                await dbContext.SaveChangesAsync();
                return Ok(patient);
            }

            return NotFound();
        }
    }
}

