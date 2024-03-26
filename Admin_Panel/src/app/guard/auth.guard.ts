
import { Injectable } from '@angular/core';
import { CanActivate, ActivatedRouteSnapshot, RouterStateSnapshot, Router } from '@angular/router';


@Injectable({
  providedIn: 'root'
})
export class AuthGuard implements CanActivate {

  constructor(private router: Router) { }

  canActivate(route: ActivatedRouteSnapshot): any {
    const token = localStorage.getItem('token');
    if (token && token != null && token !== 'null') {
      return true;
    }
    this.router.navigate(['/login']);
  }
}
