
import { NavigationExtras } from '@angular/router';
import { Component, OnInit, ViewChild } from '@angular/core';
import { Router } from '@angular/router';
import { ApiService } from '../../services/api.service';
import { UtilService } from '../../services/util.service';
import Swal from 'sweetalert2';
import { ModalDirective } from 'ngx-bootstrap/modal';

@Component({
  selector: 'app-users',
  templateUrl: './users.component.html',
  styleUrls: ['./users.component.scss']
})
export class UsersComponent implements OnInit {
  @ViewChild('myModal2') public myModal2: ModalDirective;
  firstName: any = '';
  lastName: any = '';
  venueName: any = '';
  venueAddress: any = '';
  email: any = '';
  password: any = '';
  countryCode: any = '';
  mobile: any = '';
  gender: any = '1';
  fee_start: any = '';
  phone_second: any = '';
  cover: any = 'NA';
  selectedItems = [];
  type: any = 'user';
  cities: any[] = [];
  lat: any = '';
  address: any = '';
  have_shop: any = false;
  extraField: any = 'BACS'
  userId: any = '';
  dummy = Array(10);
  dummyUsers: any[] = [];
  users: any[] = [];
  page: number = 1;
  action: any = 'create';

  constructor(
    private router: Router,
    public api: ApiService,
    public util: UtilService) {

  }

  ngOnInit(): void {
    this.getAllUsers();
  }

  getAllUsers() {
    this.api.get_private('v1/users/getAllUsers').then((data: any) => {
      this.dummy = [];
      if (data && data.status && data.status == 200 && data.success) {
        console.log(">>>>>", data);
        if (data && data.data.length > 0) {
          this.users = data.data;
          this.dummyUsers = data.data;
          console.log("======", this.users);
        }
      }
    }, error => {
      this.dummy = [];
      console.log('Error', error);
      this.util.apiErrorHandler(error);
    }).catch(error => {
      this.dummy = [];
      console.log('Err', error);
      this.util.apiErrorHandler(error);
    });
  }

  search(str: any) {
    this.resetChanges();
    console.log('string', str);
    this.users = this.filterItems(str);
  }


  protected resetChanges = () => {
    this.users = this.dummyUsers;
  }

  filterItems(searchTerm: any) {
    return this.users.filter((item) => {
      var name = item.venue_name + " " + item.last_name;
      return name.toLowerCase().indexOf(searchTerm.toLowerCase()) > -1;
    });
  }

  setFilteredItems() {
    console.log('clear');
    this.users = [];
    this.users = this.dummyUsers;
  }

  getClass(item: any) {
    if (item == '1' || item == 1) {
      return 'badge badge-success';
    } else if (item == '0' || item == 0) {
      return 'badge badge-danger';
    }
    return 'badge badge-warning';
  }

  viewsInfo(item: any) {
    console.log(item);
    const param: NavigationExtras = {
      queryParams: {
        id: item
      }
    };
    this.router.navigate(['users-details'], param);
  }

  deleteItem(item: any) {
    console.log(item);
    Swal.fire({
      title: this.util.translate('Are you sure?'),
      text: this.util.translate('To Delete this user!'),
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
        this.util.show();
        this.api.post_private('v1/users/deleteUser', item).then((datas) => {
          this.util.hide();
          this.util.success(this.util.translate('Deleted'));
          this.getAllUsers();
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

  createNew() {
    this.action = 'create';
    this.myModal2.show();
  }

  createUser() {
    console.log('create user');
    console.log(this.firstName);
    console.log(this.lastName);
    console.log(this.email);
    console.log(this.password);
    console.log(this.countryCode);
    console.log(this.mobile);
    console.log(this.cover);
    console.log(this.venueAddress);
    console.log(this.venueName);
  
    if (this.firstName == '' || this.lastName == '' || this.email == '' || this.password == '' || this.countryCode == '' || this.mobile == ''
    ) {
      this.util.error(this.util.translate('All Fields are required'));
      return false;
    }
  
    const param = {
      email: this.email,
      type: this.type,
      gender: this.gender,
      password: this.password,
      first_name: this.firstName,
      last_name: this.lastName,
      extra_field: this.extraField,
      mobile: this.mobile,
      cover: this.cover,
      country_code: this.countryCode,
      venue_name: this.venueName, 
      venue_address: this.venueAddress, 
      // Add other properties as needed
    };
  
    this.util.show();
    this.api.post_private('v1/auth/create_user_account', param).then((data: any) => {
      this.util.hide();
      console.log(data);
      if (data.status == 500) {
        this.util.error(data.message);
      }
      if (data && data.status && data.status == 200 && data.user && data.user.id) {
        // Additional logic specific to user creation...
        this.saveUserProfile(data.user.id);
        // Example: Display success message and clear form
        this.util.success(this.util.translate('User created successfully!'));
        this.clearData(); // Implement the clearData method to reset form fields
        this.getAllUsers();
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

  saveUserProfile(id: any){
    console.log('id', id);
    const ids = this.selectedItems.map((x: any) => x.id);
    console.log(ids);
    const body = {
      id: id,
      status: 1,
      type: 'user',
      cover: this.cover,
      address: this.address,
      email: this.email,
      password: this.password,
      first_name: this.firstName,
      last_name: this.lastName,
      mobile: this.mobile,
      country_code: this.countryCode,
      venue_name: this.venueName,
      venue_address: this.venueAddress, 
      extra_field: 'BACS',
      images: 'NA',
      rating: 0,
      total_rating: 0,
      verified: 1,
      available: 1,
      background: 'NA',
    };
    this.util.show();
    this.api.post_private('v1/auth/create_user_account', body).then((data: any) => {
      console.log("+++++++++++++++", data);
      this.util.hide();
      if (data && data.status && data.status == 200 && data.success) {
        this.myModal2.hide();
        this.getAllUsers;
        this.clearData();
        this.util.success(this.util.translate('User added !'));
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
    this.venueAddress = '';
    this.venueName = '';
    this.email = '';
    this.password = '';
    this.countryCode = '';
    this.mobile = '';
    this.lat = '';
    this.cover = '';
    this.fee_start = '';
    this.have_shop = false;
  }


  statusUpdate(item: any) {
    console.log(item);
    const text = item.status == 1 ? 'Deactive' : 'Active';
    Swal.fire({
      title: this.util.translate('Are you sure?'),
      text: this.util.translate('To ') + this.util.translate(text) + this.util.translate(' this user!'),
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
        const query = item.status == 1 ? 0 : 1;
        item.status = query;
        this.util.show();
        this.api.post_private('v1/profile/update', item).then((datas) => {
          this.util.hide();
          this.util.success(this.util.translate('Updated'));
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

  exportCSV() {
    let data: any = [];
    this.users.forEach(element => {
      const info = {
        'id': this.util.replaceWithDot(element.id),
        'first_name': this.util.replaceWithDot(element.first_name),
        'last_name': this.util.replaceWithDot(element.last_name),
        'cover': this.util.replaceWithDot(element.cover),
        'country_code': this.util.replaceWithDot(element.country_code),
        'mobile': this.util.replaceWithDot(element.mobile),
        'email': this.util.replaceWithDot(element.email),
      }
      data.push(info);
    });
    const name = 'users';
    this.util.downloadFile(data, name, ['id', 'first_name', 'last_name', 'cover', 'country_code', 'mobile', 'email']);
  }

  updateUser() {
    if (this.firstName == '' || this.lastName == '' || this.email == '' || this.password == '' || this.countryCode == '' || this.mobile == '' || this.cover == '') {
      this.util.error(this.util.translate('All Fields are required'));
      return false;
    }
    const ids = this.selectedItems.map((x: any) => x.id);
    console.log(ids);
    const body = {
      id: this.userId,
      cover: this.cover,
      status: 1,
      type: 'user',
      address: this.address,
      email: this.email,
      password: this.password,
      first_name: this.firstName,
      last_name: this.lastName,
      mobile: this.mobile,
      country_code: this.countryCode,
      venue_name: this.venueName,
      venue_address: this.venueAddress, 
      extra_field: 'BACS',
      images: 'NA',
      rating: 0,
      verified: 1,
      available: 1,
      background: 'NA',
    };
    this.util.show();
    this.api.post_private('v1/profile/update', body).then((data: any) => {
      console.log("+++++++++++++++", data);
      this.util.hide();
      if (data && data.status && data.status == 200 && data.success) {
        this.myModal2.hide();
        this.getAllUsers();
        this.clearData();
        this.util.success(this.util.translate('Individual updated !'));
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
}
