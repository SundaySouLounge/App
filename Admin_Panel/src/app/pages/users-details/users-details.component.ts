
import { Component, OnInit} from '@angular/core';
import { ActivatedRoute, NavigationExtras, Router } from '@angular/router';
import { ApiService } from '../../services/api.service';
import { UtilService } from '../../services/util.service';
import * as moment from 'moment';
import Swal from 'sweetalert2';
import * as bcrypt from 'bcryptjs';


@Component({
  selector: 'app-users-details',
  templateUrl: './users-details.component.html',
  styleUrls: ['./users-details.component.scss']
})
export class UsersDetailsComponent implements OnInit {
  uid: any = '';
  name: any = '';
  lastname: any = '';
  firstname: any = '';
  cover: any = '';
  email: any = '';
  phone: any = '';
  pass: any = '';
  venueName: any = '';
  venueAddress: any = '';
  secondPhone: any = '';
  yourAuthToken: any = '';
  isEditing: boolean = false;
  userId: any = '';
  passwordSecond: string = '';


  appointments: any[] = [];
  productsOrders: any[] = [];
  address: any[] = [];
  ratings: any[] = [];
  ratingsProducts: any[] = [];
  constructor(
    public util: UtilService,
    public api: ApiService,
    private route: ActivatedRoute,
    private router: Router
  ) {
    this.route.queryParams.subscribe((data: any) => {
      console.log(data);
      if (data && data.id) {
        this.uid = data.id;
        console.log('BAAAS:', this.uid); 
        this.getUserInfo();
      }
    });
  }

  toggleEditing() {
    this.isEditing = !this.isEditing;
  }

  async resetPassword() {
    const hashedPassword = await bcrypt.hash(this.pass, 10);

    const updateData = {
      id: this.uid, // Use the provided user ID parameter
      password: hashedPassword,
    };

    console.log('Update Credentials Request:', updateData); // Add this line for debugging

    // Make an API call to update email and password
    this.util.show();
    this.api.post_private('v1/profile/update', updateData).then((data: any) => {
      console.log('Update Credentials Response:', data); // Add this line for debugging
      this.util.hide();
      if (data && data.status && data.status === 200 && data.success) {
        this.util.success(this.util.translate('Password updated successfully'));
      } else {
        this.util.error(this.util.translate('Failed to update password'));
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
  
  saveChanges() {
  this.updateBasicInformation();
  this.isEditing = false;
  }
  
 updateBasicInformation() {
    const updateData = {
      id: this.uid, // Use the provided user ID parameter
      first_name: this.firstname,
      last_name: this.lastname,
      email: this.email,
      mobile: this.phone,
      venue_name: this.venueName,
      venue_address: this.venueAddress,
      phone_second: this.secondPhone,
    };
  
    console.log('Update Basic Information Request:', updateData); // Add this line for debugging
  
    // Make an API call to update basic information
    this.util.show();
    this.api.post_private('v1/profile/update', updateData).then((data: any) => {
      console.log('Update Basic Information Response:', data); // Add this line for debugging
      this.util.hide();
      if (data && data.status && data.status === 200 && data.success) {
        this.util.success(this.util.translate('Basic information updated successfully'));
      } else {
        this.util.error(this.util.translate('Failed to update basic information'));
      }
    }, error => {
      console.log('Update Basic Information Error:', error); // Add this line for debugging
      this.util.hide();
      this.util.apiErrorHandler(error);
    }).catch(error => {
      console.log('Update Basic Information Catch Error:', error); // Add this line for debugging
      this.util.hide();
      this.util.apiErrorHandler(error);
    });
  }
  
  
  getUserInfo() {
    this.util.show();
    this.api.post_private('v1/users/userInfoAdmin', { id: this.uid }).then((data: any) => {
      console.log(data);
      this.util.hide();
      if (data && data.status && data.status == 200) {
        const info = data.data;
        console.log('info', info);
        this.name = info.user.first_name + ' ' + info.user.last_name;
        this.firstname = info.user.first_name;
        this.lastname = info.user.last_name;
        this.cover = info.user.cover;
        this.email = info.user.email;
        this.venueName = info.user.venue_name;
        this.venueAddress = info.user.venue_address;
        this.secondPhone = info.user.phone_second;
        this.phone = info.user.country_code + info.user.mobile;
        this.passwordSecond = info.user.password_second;
        this.userId = info.user.id;

        info.appointments.forEach((element: any) => {
          if (((x) => { try { JSON.parse(x); return true; } catch (e) { return false } })(element.items)) {
            element.items = JSON.parse(element.items);
            element.created_at = moment(element.created_at).format('dddd, MMMM Do YYYY');
          }
        });
        info.productsOrders.forEach((element: any) => {
          if (((x) => { try { JSON.parse(x); return true; } catch (e) { return false } })(element.orders)) {
            element.orders = JSON.parse(element.orders);
          }
        });
        this.appointments = info.appointments;
        this.productsOrders = info.productsOrders;
        this.address = info.address;
        this.ratings = info.rating;
        this.ratingsProducts = info.ratingProducts;
      }
    }, error => {
      console.log(error);
      this.util.hide();
      this.util.apiErrorHandler(error);
    }).catch(error => {
      console.log(error);
      this.util.hide();
      this.util.apiErrorHandler(error);
    });
  }
  ngOnInit(): void {
  }

  getImage() {
    return this.api.imageUrl + this.cover;
  }

  viewData(id: any) {
    console.log(id);
    const param: NavigationExtras = {
      queryParams: {
        id: id
      }
    }
    this.router.navigate(['appointments-details'], param);
  }

  viewDataProduct(id: any) {
    const param: NavigationExtras = {
      queryParams: {
        id: id
      }
    }
    this.router.navigate(['orders-details'], param);
  }

  getTitle(num: any) {
    const title = [this.util.translate('Home'), this.util.translate('Work'), this.util.translate('Others')];
    return title[num];
  }

  deleteAddress(item: any) {
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

        this.util.show();
        this.api.post_private('v1/address/delete', { id: item.id }).then((data: any) => {
          console.log(data);
          this.util.hide();
          if (data && data.status && data.status == 200) {
            // this.getList();
            this.address = this.address.filter(x => x.id! = item.id);
          }
        }).catch(error => {
          console.log(error);
          this.util.hide();
          this.util.apiErrorHandler(error);
        });
      }
    });
  }

  getDate(date: any) {
    return moment(date).format('lll');
  }
}
