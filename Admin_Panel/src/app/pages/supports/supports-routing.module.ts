
import { NgModule } from '@angular/core';
import { RouterModule, Routes } from '@angular/router';
import { SupportsComponent } from './supports.component';

const routes: Routes = [
  {
    path: '',
    component: SupportsComponent
  }
];

@NgModule({
  imports: [RouterModule.forChild(routes)],
  exports: [RouterModule]
})
export class SupportsRoutingModule { }
