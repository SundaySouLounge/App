
import { NgModule } from '@angular/core';
import { RouterModule, Routes } from '@angular/router';
import { AppointmentsDetailsComponent } from './appointments-details.component';

const routes: Routes = [
  {
    path: '',
    component: AppointmentsDetailsComponent
  }
];

@NgModule({
  imports: [RouterModule.forChild(routes)],
  exports: [RouterModule]
})
export class AppointmentsDetailsRoutingModule { }
