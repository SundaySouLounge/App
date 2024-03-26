
import { NgModule } from '@angular/core';
import { RouterModule, Routes } from '@angular/router';
import { BlogsDetailsComponent } from './blogs-details.component';

const routes: Routes = [
  {
    path: '',
    component: BlogsDetailsComponent
  }
];

@NgModule({
  imports: [RouterModule.forChild(routes)],
  exports: [RouterModule]
})
export class BlogsDetailsRoutingModule { }
