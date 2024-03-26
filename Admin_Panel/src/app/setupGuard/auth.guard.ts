
import { Injectable } from '@angular/core';
import { CanActivate, ActivatedRouteSnapshot, RouterStateSnapshot, Router } from '@angular/router';
import { ApiService } from '../services/api.service';

@Injectable({
  providedIn: 'root'
})
export class SetupAuthGuard implements CanActivate {

  constructor(
    public api: ApiService,
    private router: Router) { }

  canActivate(route: ActivatedRouteSnapshot): any {
    return this.api.get_public('v1/users/get_admin').then((user: any) => {
      console.log('user', user);
      if (user && user.status == 200) {
        return true;
      } else {
        this.router.navigate(['/register']);
      }
    }).catch(error => {
      console.log(error);
      this.router.navigate(['/register']);
    });
  }
}
