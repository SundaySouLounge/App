
import { NgModule } from '@angular/core';
import { RouterModule, Routes } from '@angular/router';
import { ComplaintsComponent } from './complaints.component';

const routes: Routes = [
  {
    path: '',
    component: ComplaintsComponent
  }
];

@NgModule({
  imports: [RouterModule.forChild(routes)],
  exports: [RouterModule]
})
export class ComplaintsRoutingModule { }
