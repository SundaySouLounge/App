
import { NgModule } from '@angular/core';
import { RouterModule, Routes } from '@angular/router';
import { AppPagesComponent } from './app-pages.component';
const routes: Routes = [
  {
    path: '',
    component: AppPagesComponent
  }
];

@NgModule({
  imports: [RouterModule.forChild(routes)],
  exports: [RouterModule]
})
export class AppPagesRoutingModule { }
