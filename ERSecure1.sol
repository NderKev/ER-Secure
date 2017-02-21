contract ERSecure{                                                                                                                                                                                                                                                 
	uint patients;
	address public Patient;
    uint public ratingQuorum;
	string public inviteEmail;
	string Public doctorName;
	string public description;
	string public RegistrationToken;
    uint public AppointmentsAwaitPeriodInMinutes;
	uint public consultationPeriodInMinutes;
    int public leadingDoctorRating;
    uint public numAppointments;
	uint public numConsultations;
	uint public Registeredpatients;
	uint public ConsultationID;
	
	Appointment[] appointments;
	mapping (address => Doctor) public memberIdentity;
    mapping (address => ShareHolder) public memberIdentity;
	mapping (address => Insurer) public memberIdentity;
	mapping (address => HospitalAdmin) public memberIdentity;
	mapping (address => paymentMethod) public memberIdentity;
	mapping (uint => ShareHolder) public memberId;
	mapping (string => Doctor ) public DoctorSearch;
	mapping (uint => Appointment) public AppointmentsLookUp;
	mapping (uint => Consultation) public ConsultationLookUp;
	mapping (uint => DoctorRating ) public DoctorRatingLookUp;
	mapping (string => Insurer ) public InsurerLookUp;
	mapping (string => HospitalAdmin ) public HospitalAdminLookUp;
	mapping (string => paymentMethod ) public paymentMethodLookUp;
	
	event doctorInvitation(string DocRegEmail, string DocRegToken);
    event AppointmentsAdded(string description);
	event ConsultationAdded(string description);
    event NumOfDocConsultation(uint ConsultationID, string doctorName);
	event NumOfAppointments(uint AppointmentsID, bool supportsAppointments, address sender, string justificationText);
    event AppointmentsTallied(uint AppointmentsID, int result, uint quorum, bool active);
	event ConsultationTallied(uint ConsultationID, uint participantpatients, address selectedDoctor, uint TimeLogged,uint amount);
    event userRegistered(address member, bool isMember);
	event endofConsultation(uint starttime, uint consultationPeriodInMinutes);
	event requestConsultation(uint consultationPeriodInMinutes);
	event uploadProceduralPlan(byte[1024] docData);
	event authenticateFingerPrintHash(byte[1024] fingerPrint);
	event approveDoctor(bool certified);
	event approvePayment(bool valid);
	

    struct Appointment {
        string description;
        uint AppointmentsDeadline;
		uint consultationCreationTime;
		uint consultationExecutionTime;
		uint timeToExpire;
		address consultedDoctor;
		address consultingPatient;
		bool inviteDoc;
        bool termsAgreed;
        bool AppointmentsPassed;
        uint patientsAttended;
        date currentDate;
		date scheduledDate;
        ProceduralPlan[] proceduralPlans;
        mapping (address => bool) approveProceduralPlan;
		mapping (address => ProceduralPlan) querryAppointments;
    }
	struct Consultation {
        string ConsultationDescription;
		uint consultationPeriodInMinutes;
        uint AppointmentsDeadline;
		uint consultationStartTime;
		uint consultationEndTime;
		uint timeToExpire;
		address selectedDoctor;
		address HighestRankedDoc;
		address consultingPatient;
		address consultingDoctor;
        bool endofConsultation;
	    uint participantpatients;
        uint numberOfDoctors;
		uint chargedAmount;
        ProceduralPlan[] proceduralPlans;
        mapping (address => bool) approveProceduralPlan;
		mapping (string => DoctorRating) querryDoctor;
		mapping (uint => DoctorRating) queryDoctorRating;
		mapping (address => DoctorRating) querryDoctorRating;
    }
	struct DoctorRating {
	    uint DoctorID;
        bool isDoctor;
        address doctor;
        string doctorName;
		uint doctorRating;
		uint attendedPatients;
		uint writtenProceduralPlans;
    }
	
    struct ShareHolder{
        uint id;
        address member;
        bool canViewProceduralPlan;
        string name;
        uint memberSince;
    }
	 struct Insurer{
        uint InsurerId;
        address insurer;
        bool canViewProceduralPlan;
        string insurerName;
		string Location;
		string [] address;
        uint memberSince;
    }
   struct HospitalAdmin{
        uint HospitalAdminId;
        address HospitalAdmin;
        bool canViewProceduralPlan;
        string HospitalAdminName;
		string Location;
		string [] address;
        uint memberSince;
    }
    struct paymentMethod{
        uint paymentMethodId;
        address paymentMethod;
        bool canViewProceduralPlan;
        string paymentMethodName;
		string Location;
		string [] address;
        uint TimeLogged;
    }
	struct Doctor{
        uint DoctorId;
        address doctor;
        bool canViewProceduralPlan;
		byte[1024] profPic;
        string DoctorName;
		string Location;
		string [] coverletter;
		int jobscompleted;
		uint rating;
		string [] address;
        uint memberSince;
    }
	
	struct Patient{
        uint PatientId;
        address patient;
        bool canViewProceduralPlan;
		byte[1024] profPic;
        string DoctorName;
		string Location;
		string [] about;
		int completedAppointments;
		uint rating;
		string [] address;
        uint memberSince;
    }
	
    struct ProceduralPlan {
        bool approved;
        address proceduralPlan;
        string justification;
		byte[1024] docFile;
		byte[1024] ICD-10File;
		
    }
	 
    
    /* modifier that allows only shareholders to ProceduralPlan and create new Appointmentss */
    modifier onlyMembers {	
       if(msg.sender != memberIdentity[msg.sender].member) return;
      _
    }
    
    modifier onlyOwner {
        if (msg.sender != Patient) return;
        _
    }
	modifier onlyDoctor {
        if (msg.sender != Doctor) return;
        _
    }
    /* First time setup */
	
    function ERSecure{() {
     Patient = msg.sender;
    }
	function switchDoctor(address Doctor) onlyDoctor {
        Doctor = Doctor;
    }

	funtion InviteDoctor(string invitationEmail) onlyOwner  returns(emailregistrationToken)
	{
	doctorInvitation=invitationEmail;
	RegistrationToken = emailregistrationToken;
	
	 doctorInvitation(doctorInvitation, RegistrationToken);
	}
	   function registerpatient(address targetMember, bool canViewProceduralPlan, string memberName)  onlyOwner returns(uint patient) 
    {
		patient = Registeredpatients;
		memberId[patient].id = patient;
		memberId[patient].member = targetMember;
		memberId[patient].canViewProceduralPlan = canViewProceduralPlan;
		memberId[patient].name = memberName;
		memberId[patient].memberSince = now;
	    memberIdentity[targetMember].member = targetMember;
        memberIdentity[targetMember].id = patient++;
		memberIdentity[targetMember].canViewProceduralPlan = canViewProceduralPlan;
		memberIdentity[targetMember].name = memberName;
		memberIdentity[targetMember].memberSince = now;
	
		Registeredpatients++;

        userRegistered(targetMember, canViewProceduralPlan);

    }
    }