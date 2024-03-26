
import { Component, OnInit, ViewChild, ElementRef, ChangeDetectorRef } from '@angular/core';
import { ModalDirective } from 'ngx-bootstrap/modal';
import { ApiService } from 'src/app/services/api.service';
import { UtilService } from 'src/app/services/util.service';
import Swal from 'sweetalert2';
import * as bcrypt from 'bcryptjs';
import { formatDate } from '@angular/common';

@Component({
  selector: 'app-salons',
  templateUrl: './salons.component.html',
  styleUrls: ['./salons.component.scss']
})
export class SalonsComponent implements OnInit {
  @ViewChild('myModal2') public myModal2: ModalDirective;
  @ViewChild('imageInput') imageInput: ElementRef;
  firstName: any = '';
  lastName: any = '';
  email: any = '';
  password: any = '';
  ema: any = '';
  pass: any = '';
  phoneN: any = '';
  country_code: any = '';
  mobile: any = '';
  gender: any = '1';
  cover: any = '';
  categories: any[] = [];
  selectedItems = [];
  cities: any[] = [];
  lat: any = '';
  name: any = '';
  address: any = '';
  have_shop: any = false;
  service_at_home: any = false;
  have_stylist: any = false;
  lng: any = '';
  about: any = '';
  website: any = '';
  cityID: any = '';
  zipcode: any = '';
  //package
  solopack: any = '';
  instrumentsList: string[] = ['Vocals', 'Keys/Piano', 'Jazz Piano', 'Acoustic Guitar', 'Electric Guitar', 'Jazz Guitar', 'Bass Guitar', 'Double Bass', 'Drums/Cajon', 'Percussion', 'Saxophone', 'Trumpet', 'Harmonica', 'Loop Pedal', 'Stomp Box', 'Dj Console'];
  soloinstru: string[] = []; 
  weddingpack: any = '';
  weddinginstru: string[] = [];
  traveler: any = '';
  dropdownProp = {
    singleSelection: false,
    idField: 'id',
    textField: 'name',
    selectAllText: 'Select All',
    unSelectAllText: 'UnSelect All',
    allowSearchFilter: true
  };

//DATE
  bsValue = new Date();
  bsRangeValue: Date[];
  maxDate = new Date();
  minDate = new Date();
  unavailableDates: Date[] = [];
  selectedDate: Date;
//VIDEO
videos: any[] = [];
isEditingVideo: boolean = false;
editedVideo: any = {};
//IMAGES 
images: string[] = [];
//Search
dummyUsers: any[] = [];
  users: any[] = [];
  dropdownSettings = {
    singleSelection: false,
    idField: 'id',
    textField: 'name',
    selectAllText: 'Select All',
    unSelectAllText: 'UnSelect All',
    allowSearchFilter: true
  };
  salons: any[] = [];
  dummySalons: any[] = [];

  salonId: any = '';
  salonUID: any = '';
  action: any = 'create';
  page: number = 1;
  rate: any = '';
  constructor(
    public api: ApiService,
    public util: UtilService,
    private cdr: ChangeDetectorRef,
  ) {
    this.getAllSalon();
    this.getAllCates();
    this.getAllCities();
    this.minDate.setFullYear(this.minDate.getFullYear() - 1);  // Example: 1 year ago
    this.maxDate.setFullYear(this.maxDate.getFullYear() + 7);  // Example: 1 year from now
    this.bsRangeValue = [this.bsValue, this.maxDate];
  }

  ngOnInit(): void {
  }

  getAllSalon() {
    this.salons = [];
    this.dummySalons = Array(5);
    console.log("====Hello");
    this.api.get_private('v1/salon/getAll').then((data: any) => {
      this.dummySalons = [];
      if (data && data.status && data.status == 200 && data.success) {
        console.log(">>>>>", data);
        if (data.data.length > 0) {
          this.salons = data.data;
          console.log("====", this.salons);
        }
      }
    }, error => {
      this.dummySalons = [];
      console.log('Error', error);
      this.util.apiErrorHandler(error);
    }).catch(error => {
      this.dummySalons = [];
      console.log('Err', error);
      this.util.apiErrorHandler(error);
    });
  }

  preview_banner(files: any) {
    console.log('fle', files);
    if (files.length == 0) {
      return;
    }
    const mimeType = files[0].type;
    if (mimeType.match(/image\/*/) == null) {
      return;
    }

    if (files) {
      console.log('ok');
      this.util.show();
      this.api.uploadFile(files).subscribe((data: any) => {
        console.log('==>>>>>>', data.data);
        this.util.hide();
        if (data && data.data.image_name) {
          this.cover = data.data.image_name;
        }
      }, err => {
        console.log(err);
        this.util.hide();
      });
    } else {
      console.log('no');
    }
  }

  getAllCates() {
    ///getAll
    this.api.get_private('v1/category/getAll').then((data: any) => {
      if (data && data.status && data.status == 200 && data.success) {
        console.log(">>>>>", data);
        if (data.data.length > 0) {
          this.categories = data.data;
          console.log("====", this.categories);
        }
      }
    }, error => {
      console.log('Error', error);
      this.util.apiErrorHandler(error);
    }).catch(error => {
      console.log('Err', error);
      this.util.apiErrorHandler(error);
    });
  }

  getAllCities() {
    this.api.get_private('v1/cities/getAll').then((data: any) => {
      if (data && data.status && data.status == 200 && data.success) {
        console.log(">>>>>", data);
        if (data.data.length > 0) {
          this.cities = data.data;
        }
      }
    }, error => {
      console.log('Error', error);
      this.util.apiErrorHandler(error);
    }).catch(error => {
      console.log('Err', error);
      this.util.apiErrorHandler(error);
    });
  }


  exportCSV() {

  }

  importCSV() {

  }

  createNew() {
    this.action = 'create';
    this.myModal2.show();
  }

  createSalon() {
    console.log('create salon');
    console.log(this.firstName);
    console.log(this.lastName);
    console.log(this.email);
    console.log(this.password);
    console.log(this.country_code);
    console.log(this.mobile);
    console.log(this.selectedItems);
    console.log(this.cityID);
    console.log(this.zipcode);
    console.log(this.lat);
    console.log(this.lng);
    console.log(this.cover);
    console.log(this.have_shop);
    console.log(this.have_stylist);
    console.log(this.service_at_home);
    if (this.firstName == '' || this.lastName == '' || this.email == ''
      || this.password == '' || this.country_code == '' || this.mobile == ''
      || this.selectedItems.length <= 0 || this.cityID == '' || this.rate == ''
      || this.about == '' || this.address == ''
      || this.mobile == null || this.cover == '' || this.name == '') {
      this.util.error(this.util.translate('All Fields are required'));
      return false;
    }

    const regex = /^(([^<>()[\]\.,;:\s@\"]+(\.[^<>()[\]\.,;:\s@\"]+)*)|(\".+\"))@(([^<>()[\]\.,;:\s@\"]+\.)+[^<>()[\]\.,;:\s@\"]{2,})$/i;
    if (!regex.test(this.email)) {
      this.util.error(this.util.translate('Please enter valid Email ID'));
      return false;
    }
    console.log(typeof this.country_code)
    const cc: string = (this.country_code).toString();
    if (!cc.includes('+')) {
      this.country_code = '+' + this.country_code
    };

    const param = {
      first_name: this.firstName,
      last_name: this.lastName,
      gender: this.gender,
      cover: this.cover,
      mobile: this.mobile,
      email: this.email,
      country_code: this.country_code,
      password: this.password,
      //pacakges
      acustic_solo: this.solopack,
      acustic_soloinstru: this.soloinstru,
      wedding: this.weddingpack,
      weddinginstru: this.weddingpack,
      travel: this.traveler
    };
    this.util.show();
    this.api.post_private('v1/auth/createSalonAccount', param).then((data: any) => {
      this.util.hide();
      console.log(data);
      if (data.status == 500) {
        this.util.error(data.message);
      }
      if (data && data.status && data.status == 200 && data.user && data.user.id) {
        console.log(data);
        this.saveSalonProfile(data.user.id);
      } else if (data && data.error && data.error.msg) {
        this.util.error(data.error.msg);
      } else if (data && data.error && data.error.message == 'Validation Error.') {
        for (let key in data.error[0]) {
          console.log(data.error[0][key][0]);
          this.util.error(data.error[0][key][0]);
        }
      } else {
        this.util.error(this.util.translate('Something went wrong'));
      }
    }, error => {
      console.log(error);
      this.util.hide();
      if (error && error.error && error.error.status == 500 && error.error.message) {
        this.util.error(error.error.message);
      } else if (error && error.error && error.error.error && error.error.status == 422) {
        for (let key in error.error.error) {
          console.log(error.error.error[key][0]);
          this.util.error(error.error.error[key][0]);
        }
      } else {
        this.util.error(this.util.translate('Something went wrong'));
      }
    }).catch(error => {
      console.log(error);
      this.util.hide();
      if (error && error.error && error.error.status == 500 && error.error.message) {
        this.util.error(error.error.message);
      } else if (error && error.error && error.error.error && error.error.status == 422) {
        for (let key in error.error.error) {
          console.log(error.error.error[key][0]);
          this.util.error(error.error.error[key][0]);
        }
      } else {
        this.util.error(this.util.translate('Something went wrong'));
      }
    });
  }

  saveSalonProfile(uid: any) {
    console.log('uid', uid);
    const ids = this.selectedItems.map((x: any) => x.id);
    console.log(ids);
    const body = {
      uid: uid,
      name: this.name,
      status: 1,
      lat: 51.50660558,
      lng: -0.08789062,
      cover: this.cover,
      categories: ids.join(),
      address: this.address,
      about: this.about,
      images: 'NA',
      cid: this.cityID,
      zipcode: 1214,
      rating: 0,
      total_rating: 0,
      website: "NA",
      timing: "NA",
      verified: 1,
      available: 1,
      have_shop: this.have_shop == true ? 1 : 0,
      service_at_home: this.service_at_home == true ? 1 : 0,
      have_stylist: this.have_stylist == true ? 1 : 0,
      popular: 0,
      in_home: 1,
      extra_field: 'NA',
      rate: this.rate,
      //pacakges
      acustic_solo: this.solopack,
      acustic_soloinstru: this.soloinstru,
      wedding: this.weddingpack,
      weddinginstru: this.weddingpack,
      travel: this.traveler
    };
    this.util.show();
    this.api.post_private('v1/salon/create', body).then((data: any) => {
      console.log("+++++++++++++++", data);
      this.util.hide();
      if (data && data.status && data.status == 200 && data.success) {
        this.myModal2.hide();
        this.getAllSalon();
        this.clearData();
        this.util.success(this.util.translate('Salon added !'));
      }
    }, error => {
      this.util.hide();
      console.log('Error', error);
      this.util.apiErrorHandler(error);
    }).catch(error => {
      this.util.hide();
      console.log('Err', error);
      this.util.apiErrorHandler(error);
    });
  }

  clearData() {
    this.firstName = '';
    this.lastName = '';
    this.email = '';
    this.password = '';
    this.country_code = '';
    this.mobile = '';
    this.selectedItems = [];
    this.name = '';
    this.cityID = ''
    this.zipcode = '';
    this.lat = '';
    this.lng = '';
    this.about = '';
    this.cover = '';
    this.have_shop = false;
    this.have_stylist = false;
    this.service_at_home = false;
    this.rate = '';
    //pacakges
    this.solopack = '';
    //this.weddinginstru = '';
    this.weddingpack = '';
    this.traveler = '';
  }

  changeShop(item: any) {
    console.log(item);
    const body = {
      id: item.id,
      have_shop: item.have_shop == 0 ? 1 : 0
    };
    console.log("======", body);
    this.util.show();
    this.api.post_private('v1/salon/update', body).then((data: any) => {
      this.util.hide();
      console.log("+++++++++++++++", data);
      if (data && data.status && data.status == 200 && data.success) {
        this.util.success(this.util.translate('Status Updated !'));
        this.getAllSalon();
      }
    }, error => {
      this.util.hide();
      console.log('Error', error);
      this.util.apiErrorHandler(error);
    }).catch(error => {
      this.util.hide();
      console.log('Err', error);
      this.util.apiErrorHandler(error);
    });
  }

  changeHome(item: any) {
    console.log(item);
    const body = {
      id: item.id,
      in_home: item.in_home == 0 ? 1 : 0
    };
    console.log("======", body);
    this.util.show();
    this.api.post_private('v1/salon/update', body).then((data: any) => {
      this.util.hide();
      console.log("+++++++++++++++", data);
      if (data && data.status && data.status == 200 && data.success) {
        this.util.success(this.util.translate('Status Updated !'));
        this.getAllSalon();
      }
    }, error => {
      this.util.hide();
      console.log('Error', error);
      this.util.apiErrorHandler(error);
    }).catch(error => {
      this.util.hide();
      console.log('Err', error);
      this.util.apiErrorHandler(error);
    });
  }

  changePopular(item: any) {
    console.log(item);
    const body = {
      id: item.id,
      popular: item.popular == 0 ? 1 : 0
    };
    console.log("======", body);
    this.util.show();
    this.api.post_private('v1/salon/update', body).then((data: any) => {
      this.util.hide();
      console.log("+++++++++++++++", data);
      if (data && data.status && data.status == 200 && data.success) {
        this.util.success(this.util.translate('Status Updated !'));
        this.getAllSalon();
      }
    }, error => {
      this.util.hide();
      console.log('Error', error);
      this.util.apiErrorHandler(error);
    }).catch(error => {
      this.util.hide();
      console.log('Err', error);
      this.util.apiErrorHandler(error);
    });
  }

  changeStylist(item: any) {
    console.log(item);
    const body = {
      id: item.id,
      have_stylist: item.have_stylist == 0 ? 1 : 0
    };
    console.log("======", body);
    this.util.show();
    this.api.post_private('v1/salon/update', body).then((data: any) => {
      this.util.hide();
      console.log("+++++++++++++++", data);
      if (data && data.status && data.status == 200 && data.success) {
        this.util.success(this.util.translate('Status Updated !'));
        this.getAllSalon();
      }
    }, error => {
      this.util.hide();
      console.log('Error', error);
      this.util.apiErrorHandler(error);
    }).catch(error => {
      this.util.hide();
      console.log('Err', error);
      this.util.apiErrorHandler(error);
    });
  }

  changeServiceAtHome(item: any) {
    console.log(item);
    const body = {
      id: item.id,
      service_at_home: item.service_at_home == 0 ? 1 : 0
    };
    console.log("======", body);
    this.util.show();
    this.api.post_private('v1/salon/update', body).then((data: any) => {
      this.util.hide();
      console.log("+++++++++++++++", data);
      if (data && data.status && data.status == 200 && data.success) {
        this.util.success(this.util.translate('Status Updated !'));
        this.getAllSalon();
      }
    }, error => {
      this.util.hide();
      console.log('Error', error);
      this.util.apiErrorHandler(error);
    }).catch(error => {
      this.util.hide();
      console.log('Err', error);
      this.util.apiErrorHandler(error);
    });
  }

  deleteItem(item: any) {
    console.log(item);
    Swal.fire({
      title: this.util.translate('Are you sure?'),
      text: this.util.translate('To delete this item?'),
      icon: 'question',
      showConfirmButton: true,
      confirmButtonText: this.util.translate('Yes'),
      showCancelButton: true,
      cancelButtonText: this.util.translate('Cancel'),
      backdrop: false,
      background: 'white'
    }).then((data) => {
      if (data && data.value) {
        console.log('update it');
        console.log(item);
        console.log(item);
        const body = {
          id: item.id,
          uid: item.uid
        };
        console.log("======", body);
        this.util.show();
        this.api.post_private('v1/salon/destroy', body).then((data: any) => {
          this.util.hide();
          console.log("+++++++++++++++", data);
          if (data && data.status && data.status == 200 && data.success) {
            this.util.success(this.util.translate('Status Updated !'));
            this.getAllSalon();
          }
        }, error => {
          this.util.hide();
          console.log('Error', error);
          this.util.apiErrorHandler(error);
        }).catch(error => {
          this.util.hide();
          console.log('Err', error);
          this.util.apiErrorHandler(error);
        });
      }
    });
  }

  updateInfo(id: any, uid: any) {
    console.log(id, uid);
    this.salonId = id;
    this.salonUID = uid;
    this.util.show();
    this.api.post_private('v1/salon/getByUID', { id: uid }).then((data: any) => {
      console.log(data);
      this.util.hide();
      if (data && data.status && data.status == 200) {
        this.images = data.data.images === 'NA' ? [] : JSON.parse(data.data.images);

        console.log('Image URLs:', this.images);
        this.action = 'update';
        this.selectedItems = data.data.web_cates_data;
        this.cityID = data.data.cid;
        this.zipcode = data.data.zipcode;
        this.lat = data.data.lat;
        this.lng = data.data.lng;
        this.about = data.data.about;
        this.cover = data.data.cover;
        this.name = data.data.name;
        this.address = data.data.address;
        this.have_shop = data.data.have_shop;
        this.have_stylist = data.data.have_stylist;
        this.service_at_home = data.data.service_at_home;
        //pacakges
        this.solopack = data.data.acustic_solo;
        this.soloinstru = (data.data.acustic_soloinstru || '').split(',').map((value: string) => value.trim());
        this.weddinginstru = (data.data.acustic_weddinginstru|| '').split(',').map((value: string) => value.trim());
        this.weddingpack = data.data.wedding;
        this.traveler = data.data.travel;
        this.myModal2.show();
        this.getUnavailableDates(uid, 'salon');
        this.getAllVideos(uid);
      }
    }).catch(error => {
      console.log(error);
      this.util.hide();
      this.util.apiErrorHandler(error);
    });
  }
  

  statusUpdate(item: any) {
    console.log(item);
    Swal.fire({
      title: this.util.translate('Are you sure?'),
      text: this.util.translate('To update this item?'),
      icon: 'question',
      showConfirmButton: true,
      confirmButtonText: this.util.translate('Yes'),
      showCancelButton: true,
      cancelButtonText: this.util.translate('Cancel'),
      backdrop: false,
      background: 'white'
    }).then((data) => {
      if (data && data.value) {
        console.log('update it');
        const body = {
          id: item.id,
          status: item.status == 0 ? 1 : 0
        };
        console.log("======", body);
        this.util.show();
        this.api.post_private('v1/salon/update', body).then((data: any) => {
          this.util.hide();
          console.log("+++++++++++++++", data);
          if (data && data.status && data.status == 200 && data.success) {
            this.util.success(this.util.translate('Status Updated !'));
            this.getAllSalon();
          }
        }, error => {
          this.util.hide();
          console.log('Error', error);
          this.util.apiErrorHandler(error);
        }).catch(error => {
          this.util.hide();
          console.log('Err', error);
          this.util.apiErrorHandler(error);
        });
      }
    });
  }

  updateSalon() {
    if (this.cover == '' || this.name == '' || this.address == ''
      || this.about == '' || this.cityID == '' || this.zipcode == '' || this.lat == '' || this.lng == '') {
      this.util.error(this.util.translate('All Fields are required'));
      return false;
    }
    const ids = this.selectedItems.map((x: any) => x.id);
    console.log(ids);
    const body = {
      id: this.salonId,
      name: this.name,
      lat: this.lat,
      lng: this.lng,
      cover: this.cover,
      images: JSON.stringify(this.images),
      categories: ids.join(),
      address: this.address,
      about: this.about,
      cid: this.cityID,
      zipcode: this.zipcode,
      have_shop: this.have_shop == true ? 1 : 0,
      service_at_home: this.service_at_home == true ? 1 : 0,
      have_stylist: this.have_stylist == true ? 1 : 0,
      rate: this.rate,
      //package
      acustic_solo: this.solopack,
      acustic_soloinstru: Array.isArray(this.soloinstru) ? this.soloinstru.join() : '',
      wedding: this.weddingpack,
      acustic_weddinginstru: Array.isArray(this.weddinginstru) ? this.weddinginstru.join() : '',
      travel: this.traveler,
    }

    this.util.show();
    this.api.post_private('v1/salon/update', body).then((data: any) => {
      console.log("+++++++++++++++", data);
      this.util.hide();
      if (data && data.status && data.status == 200 && data.success) {
        this.myModal2.hide();
        this.getAllSalon();
        this.clearData();
        this.util.success(this.util.translate('Salon updated !'));
        this.updateCredentials(this.salonUID);
      }
    }, error => {
      this.util.hide();
      console.log('Error', error);
      this.util.apiErrorHandler(error);
    }).catch(error => {
      this.util.hide();
      console.log('Err', error);
      this.util.apiErrorHandler(error);
    });
  }

  async updateCredentials(userId: any) {
    const hashedPassword = await bcrypt.hash(this.pass, 10);

    const updateData = {
      id: userId, // Use the provided user ID parameter
      email: this.ema,
      password: hashedPassword,
      mobile: this.phoneN,
    };

    console.log('Update Credentials Request:', updateData); // Add this line for debugging

    // Make an API call to update email and password
    this.util.show();
    this.api.post_private('v1/profile/update', updateData).then((data: any) => {
      console.log('Update Credentials Response:', data); // Add this line for debugging
      this.util.hide();
      if (data && data.status && data.status === 200 && data.success) {
        this.util.success(this.util.translate('Email and password updated successfully'));
      } else {
        this.util.error(this.util.translate('Failed to update email and password'));
      }
    }, error => {
      console.log('Update Credentials Error:', error); // Add this line for debugging
      this.util.hide();
      this.util.apiErrorHandler(error);
    }).catch(error => {
      console.log('Update Credentials Catch Error:', error); // Add this line for debugging
      this.util.hide();
      this.util.apiErrorHandler(error);
    });
    }
//DATE
    getUnavailableDates(id: any, type: string) {
      const params = {
          id: id,
          type: type,
      };
  
      this.api.post_private('v1/unavailable_date/getUnavailableDatesByUid', params)
          .then((data: any) => {
              if (data.success && data.data && data.data.length > 0) {
                  // Convert date strings to Date objects
                  this.unavailableDates = data.data.map((dateString: string) => new Date(dateString));
              } else {
                  this.unavailableDates = [];
              }
          })
          .catch((error: any) => {
              console.error('Error getting unavailable dates', error);
          });
  }
  formatDate(date: Date): string {
    return formatDate(date, 'EEEE, MMM d, y', 'en-US');
}

addUnavailableDate() {
  if (this.selectedDate) {
    // Convert the selectedDate string to a Date object
    const dateObject = new Date(this.selectedDate);

    // Check if the dateObject is a valid Date
    if (!isNaN(dateObject.getTime())) {
      // Convert the selectedDate to 'YYYY-MM-DD' format
      const isoFormattedDate = dateObject.toISOString().split('T')[0];

      // Check if the user is an individual or a salon (you need to determine this based on your logic)
      const userType = 'salon'; // Change this to your logic

      // Use the API to add a new unavailable date
      this.api.post_private('v1/unavailable_date/updateUnavailableDatesByUid', {
        id: this.salonUID, // or the UID of the salon
        type: userType,
        dates: [isoFormattedDate]
      }).then((data: any) => {
        if (data.success && data.status && data.status == 200) {
          this.util.success(this.util.translate('New Date added'));
          this.unavailableDates.push(dateObject);
          // Any other logic you may want to perform after successfully adding the date
          console.log('New unavailable date added successfully');
        } else {
          this.util.success(this.util.translate('Failed to add new unavailable date'));
          console.error('Failed to add new unavailable date');
        }
      }).catch((error: any) => {
        console.error('Error adding new unavailable date', error);
      });
    } else {
      console.error('Invalid date format');
    }
  }
}
//VIDEO SECTION

deleteVideo(video: any) {
  // Call your API to delete the video
  // Example:
  this.api.post_private('v1/freelancer_videos/remove', { id: video.id }).then((data: any) => {
    if (data && data.status && data.status == 200 && data.success) {
      this.util.success('Video deleted successfully');
      // Refresh the list of videos after deletion
      this.getAllVideos(video.id);
      console.log('Video IDs:', this.videos.map((video: any) => video.id));
    }
  }, error => {
    console.log('Error', error);
    this.util.apiErrorHandler(error);
  }).catch(error => {
    console.log('Err', error);
    this.util.apiErrorHandler(error);
  });
}

getAllVideos(uid: string) {
  // Call your API to get the list of videos for the specific UID and assign it to this.videos
  // Example:
  this.api.post_private('v1/freelancer_videos/getMyVideos', { id: uid }).then((data: any) => {
    if (data && data.status && data.status == 200 && data.success) {
      // Assuming the array of videos is in the 'data' property
      this.videos = data.data;
      // Log video IDs
      console.log('Video IDs:', this.videos.map((video: any) => video.id));
    }
  }, error => {
    console.log('Error', error);
    this.util.apiErrorHandler(error);
  }).catch(error => {
    console.log('Err', error);
    this.util.apiErrorHandler(error);
  });
}


  editVideo(video: any) {
    // Enable editing mode and set the edited video
    this.isEditingVideo = true;
    this.editedVideo = { ...video }; // Create a copy of the selected video
  }

  // Add these methods to your component
startEditing(video: any) {
  // Enable editing mode for the selected video
  video.isEditing = true;
}

cancelEditing(video: any) {
  // Disable editing mode for the selected video
  video.isEditing = false;
}

updateVideo(video: any) {
  // Call your API to update the video
  // Example:
  this.api.post_private('v1/freelancer_videos/update', video).then((data: any) => {
    if (data && data.status && data.status == 200 && data.success) {
      this.util.success('Video updated successfully');
      // Disable editing mode and refresh the list of videos
      video.isEditing = false;
      this.getAllVideos(video.uid); // Assuming you need to refresh the list for a specific UID
    }
  }, error => {
    console.log('Error', error);
    this.util.apiErrorHandler(error);
  }).catch(error => {
    console.log('Err', error);
    this.util.apiErrorHandler(error);
  });
}
//IMAGES 
openImageUpload() {
  // Trigger the click event on the hidden file input
  this.imageInput.nativeElement.click();
}
onImageSelect(event: any) {
  const file = event.target.files[0];

  if (file) {
    // Upload the selected image file
    this.uploadImage(file);
  }
}

uploadImage(file: File) {
  // Implement your logic to upload the image
  // You can use the same logic as in the preview_banner method

  this.util.show();
  this.api.uploadFile([file]).subscribe((data: any) => {
    console.log('==>>>>>>', data.data);
    this.util.hide();
    if (data && data.data.image_name) {
      // Add the uploaded image to the images array
      this.images.push(data.data.image_name);

      // Call the updateSalon method to persist the changes
      this.updateSalon();
    }
  }, err => {
    console.log(err);
    this.util.hide();
  });
}


  // Method to delete an image
  deleteImage(image: string) {
    // Use SweetAlert to confirm the deletion
    Swal.fire({
      title: this.util.translate('Are you sure?'),
      text: this.util.translate('To delete this image?'),
      icon: 'question',
      showConfirmButton: true,
      confirmButtonText: this.util.translate('Yes'),
      showCancelButton: true,
      cancelButtonText: this.util.translate('Cancel'),
      backdrop: false,
      background: 'white'
    }).then((result) => {
      if (result.value) {
        // Remove the image URL from the images array
        this.images = this.images.filter((img) => img !== image);

        // Call the updateSalon method to persist the changes
        this.updateSalon();
      }
    });
  }

  //searh

  protected resetChanges = () => {
    this.users = this.dummyUsers;
  }

  filterItems(searchTerm: any) {
    return this.users.filter((item) => {
      var name = item.name ;
      return name.toLowerCase().indexOf(searchTerm.toLowerCase()) > -1;
    });
  }
  
  search(searchTerm: string) {
    console.log('Dummy individuals:', this.dummySalons);
    this.salons = searchTerm ? this.filterItems(searchTerm) : this.dummySalons;
    console.log('Filtered individuals:', this.salons);
    
  }
  
  setFilteredItems() {
    console.log('clear');
    this.users = [];
    this.users = this.dummyUsers;
  }

  onSoloPackChange() {
    console.log('Selected Solo Pack:', this.solopack);
  }

  isOptionSelected(option: string): boolean {
    return this.soloinstru.includes(option);
    this.cdr.detectChanges();
  }

  isInstrumentSelected(instrument: string): boolean {
    return this.soloinstru.includes(instrument);
  }
  
  // Method to handle instrument selection
  onInstrumentSelect(instrument: string): void {
    if (this.isInstrumentSelected(instrument)) {
      // If selected, remove from the array
      this.soloinstru = this.soloinstru.filter(i => i !== instrument);
    } else {
      // If not selected, add to the array
      this.soloinstru.push(instrument);
    }
  }

  
}
