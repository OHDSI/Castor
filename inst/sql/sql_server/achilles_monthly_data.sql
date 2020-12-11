
-- Query to return monthly count, prevalence, and proportion (within year) data for a concept_id or concept set.

  with num as (
select ar.stratum_2,
       1.0*sum(ar.count_value) count_value,
  	   count(*)over() total
  from @results_schema.achilles_results ar
  join @cdm_schema.concept c on ar.stratum_1  = cast(c.concept_id as varchar)
 where ar.analysis_id in (202,402,602,702,802,1802,2102)
   and c.concept_id in (@conceptIds)
 group by ar.stratum_2
)
select concat(num.stratum_2,'01') start_date,
       num.count_value,
       1000*num.count_value/denom.count_value as prevalence,
	   num.count_value/sum(num.count_value)over(partition by left(num.stratum_2,4)) proportion_within_year
  from num
  join @results_schema.achilles_results denom
    on num.stratum_2 = denom.stratum_1 and denom.analysis_id = 117
 order by cast(num.stratum_2 as int);

