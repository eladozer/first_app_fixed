class User {
  String name = "";
  double weight = 0;
  int cal = 0;
  int prot = 0;
  int current_cal = 0;
  int current_prot = 0;
  String weight_data = "";
  String food_data = "";
  List activity_data = [];
  int burned = 0;
  int cur_burned = 0;
  int running = 0;
  int cycling = 0;
  bool challenge_one = false;
  bool challenge_two = false;
  List meal_data = [];
  User(
      String na,
      double weit,
      int ca,
      int pro,
      int cur_cal,
      int cur_prot,
      String weight_dat,
      String fod,
      String meals,
      String activ,
      int bur,
      int cur_bur,
      int run,
      int cyc,
      int chal_one,
      int chal_two) {
    name = na;
    weight = weit;
    cal = ca;
    prot = pro;
    current_cal = cur_cal;
    current_prot = cur_prot;
    weight_data = weight_dat;
    food_data = fod;
    meal_data = meals.split("#");
    activity_data = activ.split("#");
    burned = bur;
    cur_burned = cur_bur;
    running = run;
    cycling = cyc;
    if (chal_one == 1) challenge_one = true;
    if (chal_two == 1) challenge_two = true;
  }
  void set_weight(double weit) {
    weight += weit;
  }

  void set_weight_data(String new_dat) {
    weight_data = new_dat;
  }

  void set_activity_data(String new_ac) {
    activity_data.add(new_ac);
  }

  void set_running(int run) {
    running += run;
  }

  void set_cycling(int cyc) {
    cycling += cyc;
  }

  void set_chal_one(bool val) {
    challenge_one = val;
  }

  void set_chal_two(bool val) {
    challenge_two = val;
  }
}
