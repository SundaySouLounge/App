
import { NgModule } from '@angular/core';
import { RouterModule, Routes } from '@angular/router';
import { SalonRequestComponent } from './salon-request.component';

const routes: Routes = [
  {
    path: '',
    component: SalonRequestComponent
  }
];

@NgModule({
  imports: [RouterModule.forChild(routes)],
  exports: [RouterModule]
})
export class SalonRequestRoutingModule { }
