	/// -*- tab-width: 4; Mode: C++; c-basic-offset: 4; indent-tabs-mode: nil -*-

	#ifdef USERHOOK_INIT
	void userhook_init()
	{
		// put your initialisation code here
		// this will be called once at start-up
		//if (ap_system.usb_connected)
		//  hal.uartA->begin(SERIAL0_BAUD);
	}
	#endif

	#ifdef USERHOOK_FASTLOOP
	void userhook_FastLoop()
	{
		//Using LAND for testing as GUIDED mode cannot be set without GPS Lock
		if(control_mode == GUIDED && motors.armed()) {

			float alt = 0;
			int m_count = 4;
			int c = hal.uartA->read();

			while(c==109) {

				m_count--;
				c = hal.uartA->read();
			}

			if(!m_count){
				switch(c) {

					case 49: set_mode(STABILIZE);
					break;
					case 50: set_mode(ALT_HOLD);
					break;
					case 51: set_mode(ACRO);
					break;
					case 52: set_mode(LAND);
					break;
					case 53: set_mode(LOITER);
					break;
					case 54: set_mode(RTL);
					break;
					case 55: set_mode(AUTO);
					break;
					case 56: set_mode(GUIDED);
					break;
					/*case 57: set_mode(DRIFT);
					 break;
					 case 58: set_mode(POSITION) ;
					 break;
					 case 59: set_mode(FOLLOW_ME) ;
					 break;
					 case 60: set_mode(CIRCLE) ;
					 break;              */
					case 61: do_takeoff();
					break;
					case 62:
						alt = wp_nav.get_desired_alt();
						wp_nav.set_desired_alt(alt+100);
					break;
					case 63:
						alt = wp_nav.get_desired_alt();
						wp_nav.set_desired_alt(alt-100);
					break;

					default:
					break;
				}
			}
		}

		else if(control_mode == LOITER && motors.armed()) {

			float alt= 0;
			int m_count=4;
			int c = hal.uartA->read();

			while(c==109) {
				m_count--;
				c = hal.uartA->read();
			}

			if(!m_count){
				switch(c) {

					case 49: set_mode(STABILIZE);
					break;
					case 50: set_mode(ALT_HOLD);
					break;
					//  case 51: set_mode(ACRO) ;
					break;
					case 52: set_mode(LAND);
					break;
					case 53: set_mode(LOITER);
					break;
					case 54: set_mode(RTL);
					break;
					//  case 55: set_mode(AUTO) ;
					break;
					case 56: set_mode(GUIDED);
					break;
					/*case 57: set_mode(DRIFT);
					 break;
					 case 58: set_mode(POSITION) ;
					 break;
					 case 59: set_mode(FOLLOW_ME) ;
					 break;
					 case 60: set_mode(CIRCLE) ;
					 break;              */
					case 61: do_takeoff();
					break;
					case 62:
						alt = wp_nav.get_desired_alt();
						wp_nav.set_desired_alt(alt+100);
					break;
					case 63:
						alt = wp_nav.get_desired_alt();
						wp_nav.set_desired_alt(alt-100);
					break;

					default:
					break;
				}
			}
		}

		else if(control_mode == ALT_HOLD && motors.armed())	{
			float alt = 0;
			int m_count = 4;
			int c = hal.uartA->read();
			while(c==109) {
				m_count--;
				c = hal.uartA->read();
			}

			if(!m_count) {	{
				switch(c) {

					case 49: set_mode(STABILIZE);
					break;
					case 50: set_mode(ALT_HOLD);
					break;
					//  case 51: set_mode(ACRO) ;
					break;
					case 52: set_mode(LAND);
					break;
					case 53: set_mode(LOITER);
					break;
					case 54: set_mode(RTL);
					break;
					//  case 55: set_mode(AUTO) ;
					break;
					case 56: set_mode(GUIDED);
					break;
					/*case 57: set_mode(DRIFT);
					 break;
					 case 58: set_mode(POSITION) ;
					 break;
					 case 59: set_mode(FOLLOW_ME) ;
					 break;
					 case 60: set_mode(CIRCLE) ;
					 break;              */
					case 61: do_takeoff();
					break;
					case 62:
						alt = wp_nav.get_desired_alt();
						wp_nav.set_desired_alt(alt+100);
					break;
					case 63:
						alt = wp_nav.get_desired_alt();
						wp_nav.set_desired_alt(alt-100);
					break;

					default:
					break;
				}
			}
		}

		else if(control_mode == LAND && motors.armed()){

			float alt= 0;
			int m_count=4;
			int c = hal.uartA->read();

			while(c==109){
				m_count--;
				c = hal.uartA->read();
			}

			if(!m_count) {
				switch(c) {

					case 49: set_mode(STABILIZE);
					break;
					case 50: set_mode(ALT_HOLD);
					break;
					//  case 51: set_mode(ACRO) ;
					break;
					case 52: set_mode(LAND);
					break;
					case 53: set_mode(LOITER);
					break;
					case 54: set_mode(RTL);
					break;
					//  case 55: set_mode(AUTO) ;
					break;
					case 56: set_mode(GUIDED);
					break;
					/*case 57: set_mode(DRIFT);
					 break;
					 case 58: set_mode(POSITION) ;
					 break;
					 case 59: set_mode(FOLLOW_ME) ;
					 break;
					 case 60: set_mode(CIRCLE) ;
					 break;              */
					case 61: do_takeoff();
					break;

					default:
					break;
				}
			}
		}
		return;
	}
	#endif

	#ifdef USERHOOK_50HZLOOP
	void userhook_50Hz()
	{
		/* if (control_mode == ALT_HOLD) {
		 set_mode(LAND);*/
	}
	#endif

	#ifdef USERHOOK_MEDIUMLOOP
	void userhook_MediumLoop()
	{
		// put your 10Hz code here
	}
	#endif

	#ifdef USERHOOK_SLOWLOOP
	void userhook_SlowLoop()
	{
		// put your 3.3Hz code here
	}
	#endif

	#ifdef USERHOOK_SUPERSLOWLOOP
	void userhook_SuperSlowLoop()
	{
		// put your 1Hz code here
	}
	#endif

