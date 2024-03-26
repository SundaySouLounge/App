
import { NgModule } from '@angular/core';
import { RouterModule, Routes } from '@angular/router';
import { SalonsComponent } from './salons.component';

const routes: Routes = [
  {
    path: '',
    component: SalonsComponent
  }
];

@NgModule({
  imports: [RouterModule.forChild(routes)],
  exports: [RouterModule]
})
export class SalonsRoutingModule { }
