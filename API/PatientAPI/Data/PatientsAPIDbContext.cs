using Microsoft.EntityFrameworkCore;
using PatientAPI.Models;

namespace PatientAPI.Data
{
    public class PatientsAPIDbContext : DbContext
    {

        public PatientsAPIDbContext(DbContextOptions options) : base(options)

        {

        }

        public DbSet<Patient> Patients { get; set; }
    }
}
